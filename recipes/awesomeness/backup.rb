# Perform backups
#
# To automatically transfer backups to your local machine, add:
#   after "backup:create", "backup:get"
#

before "deploy:migrate", "backup:create"

_cset(:backup_path) { "#{shared_path}/backups" }
_cset(:skip_backup_tables, ['sessions'])

namespace :backup do
  def latest
    capture("cd #{current_path}; rake -s backup:latest BACKUP_DIR=#{backup_path}").strip
  end

  # Create a backup on the server
  task :create, :roles => :db, :only => {:primary => true} do
    rails_env = fetch(:rails_env, "production")
    skip_tables = Array(skip_backup_tables).join(',')
    run "cd #{current_path}; rake backup:create RAILS_ENV=#{rails_env} BACKUP_DIR=#{backup_path} SKIP_TABLES=#{skip_tables}"
  end
  
  # Retreive a backup from the server. Gets the latest by default, set :backup_version to specify which version to copy
  task :get, :roles => :db, :only => {:primary => true} do
    version = fetch(:backup_version, latest)
    run "tar -C #{backup_path} -czf #{backup_path}/#{version}.tar.gz #{version}"
    `mkdir -p backups`
    get "#{backup_path}/#{version}.tar.gz", "backups/#{version}.tar.gz"
    run "rm #{backup_path}/#{version}.tar.gz"
    `tar -C backups -zxf backups/#{version}.tar.gz`
    `rm backups/#{version}.tar.gz`
  end
  
end