before "deploy:migrate", "backup:create"

_cset(:backup_path) { "#{shared_path}/backups" }

namespace :backup do

  # def backup_file(options = {})
  #   options = {:path => true}.merge(options)
  #   "#{options[:path] ? backup_path + '/' : ''}#{backup_name}.tar.gz"
  # end
  # 
  # def latest_backup
  #   last = capture("ls -x #{backup_path}").split.sort.last
  #   last.gsub(/\.tar\.gz$/, '') if last
  # end
  # 
  # task :default, :roles => :db, :only => {:primary => true} do
  #   create
  #   retrieve
  # end
  
  task :remote_to_local, :roles => :db, :only => {:primary => true} do
    rails_env = fetch(:rails_env, "production")
    run "cd #{current_path}; rake backup:create RAILS_ENV=#{rails_env} BACKUP_DIR=#{backup_path}"
    latest = capture "cd #{current_path}; rake -s backup:latest".strip
    run "tar -C #{backup_path} -czf #{backup_path}/#{latest}.tar.gz #{latest}"
    get "#{backup_path}/#{latest}", "backups/#{latest}.tar.gz"
    `tar -C -zxf backups/#{latest}.tar.gz`
  end

  # desc "Backup the remote production database"
  # task :create, :roles => :db, :only => {:primary => true} do
  #   backup_dir = "#{backup_path}/#{backup_name}"
  #   rails_env = fetch(:rails_env, "production")
  #   
  #   remove_command = "rm -rf #{backup_dir}; true"
  #   on_rollback { run remove_command }
  #   
  #   run "mkdir -p #{backup_dir}"
  #   run "cd #{current_path}; rake db:fixtures:dump RAILS_ENV=#{rails_env} FIXTURES_DIR=#{backup_dir}"
  #   run "cd #{current_path}; rake db:schema:dump RAILS_ENV=#{rails_env}"
  #   run "cp #{current_path}/db/schema.rb #{backup_dir}/"
  #   run "tar -C #{backup_path} -czf #{backup_file} #{backup_name}"
  #   run remove_command
  # end
end