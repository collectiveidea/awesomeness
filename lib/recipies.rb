#
# A collection of commonly-used (yet, non-intrusive) Capistrano tasks at Collective Idea.
#
Capistrano.configuration(:must_exist).load do
  
  desc "Normally called :long_deploy, this is what :deploy_with_migrations *should* be."
  task :deploy_with_migrations do
    transaction do
      update_code
      disable_web
      symlink
      migrate
    end

    restart
    enable_web
  end
  
  desc "Based on :long_deploy, this is what :deploy *should* be. (uses disable/enable_web)"
  task :deploy do
    transaction do
      update_code
      disable_web
      symlink
    end

    restart
    enable_web
  end
  
  desc "tail production log files" 
  task :tail_logs, :roles => :app do
    run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}" 
      break if stream == :err    
    end
  end

  desc "check production log files in textmate(tm)" 
  task :mate_logs, :roles => :app do

    require 'tempfile'
    tmp = Tempfile.open('w')
    logs = Hash.new { |h,k| h[k] = '' }

    run "tail -n500 #{shared_path}/log/production.log" do |channel, stream, data|
      logs[channel[:host]] << data
      break if stream == :err
    end

    logs.each do |host, log|
      tmp.write("--- #{host} ---\n\n")
      tmp.write(log + "\n")
    end

    exec "mate -w #{tmp.path}" 
    tmp.close
  end

  desc "remotely console" 
  task :console, :roles => :app do
    input = ''
    run "cd #{current_path} && ./script/console production" do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
    end
  end

  desc "Backup the database before running migrations"
  task :before_migrate do 
    backup
  end


  desc "Backup the remote production database"
  task :backup, :roles => :db, :only => { :primary => true } do
    require 'yaml'
    
    filename = "#{application}.dump.#{Time.now.to_i}.sql.bz2"
    file = "/tmp/#{filename}"
    on_rollback { delete file }
    db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), 'database.yml'))).result)['production']
    run "mysqldump -u #{db['username']} --password=#{db['password']} #{db['database']} | bzip2 -c > #{file}"  do |ch, stream, out|
      puts out
    end
    `mkdir -p #{File.dirname(__FILE__)}/../backups/`
    get file, "backups/#{filename}"
    # capistrano < 1.4
    # `rsync #{user}@#{roles[:db][0].host}:#{filename} #{File.dirname(__FILE__)}/../backups/`
    delete file
  end
end