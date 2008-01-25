namespace :logs do
  desc "tail production log files" 
  task :tail, :roles => :app do
    run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}" 
      break if stream == :err    
    end
  end
  
  desc "Backup the remote production log"
  task :backup, :roles => :app do
    dir = File.expand_path(File.dirname(__FILE__) + '/../../../../backups')
    filename = "#{application}.#{Time.now.to_i}.production.log"
    `mkdir -p #{dir}`
    get "#{shared_path}/log/production.log", "#{dir}/#{filename}"
  end
  

  desc "check production log files in textmate(tm)" 
  task :mate, :roles => :app do
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
end