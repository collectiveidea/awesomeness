before "deploy:migrate", "backup:create"

namespace :backup do

  def set_backup_config
    _cset :backups_path, "#{shared_path}/backups"
    _cset :backup_name, Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
  
  task :default, :roles => :db, :only => {:primary => true} do
    set_backup_config
    create
  end

  desc "Backup the remote production database"
  task :create, :roles => :db, :only => {:primary => true} do
    set_backup_config
    backup_dir = "#{backups_path}/#{backup_name}"
    rails_env = fetch(:rails_env, "production")
    
    remove_command = "rm -rf #{backup_dir}; true"
    on_rollback { run remove_command }
    
    run "mkdir -p #{backup_dir}"
    run "cd #{current_path}; rake db:fixtures:dump RAILS_ENV=#{rails_env} FIXTURE_DIR=#{backup_dir}"
    run "cp #{current_path}/db/schema.rb #{backup_dir}/"
    run "tar -C #{backups_path} -czf #{backup_name}.tar.gz #{backup_dir}"
    run remove_command
    get "#{backup_dir}.tar.gz", "backups/"
    # require 'yaml'
    # 
    # filename = "#{application}.dump.#{Time.now.to_i}.sql.bz2"
    # tmpfile = "/tmp/#{filename}"
    # delete_command = "rm -f #{tmpfile}"
    # on_rollback { run delete_command }
    # db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'database.yml'))).result)[fetch(:rails_env, 'production')]
    # host = db['host'] ? "-h #{db['host']}" : ''
    # 
    # run "mysqldump #{host} -u #{db['username']} --password=#{db['password']} #{db['database']} | bzip2 -c > #{tmpfile}"  do |ch, stream, out|
    #   puts out
    # end
    # `mkdir -p #{File.dirname(__FILE__)}/../../../../backups/`
    # get tmpfile, "backups/#{filename}"
    # run delete_command
  end
end