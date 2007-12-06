#before "deploy:migrate", "backup:create"

_cset(:backup_path) { "#{shared_path}/backups" }

namespace :backup do
  # FIXME: break this out so parts can be run separately
  task :remote_to_local, :roles => :db, :only => {:primary => true} do
    rails_env = fetch(:rails_env, "production")
    run "cd #{current_path}; rake backup:create RAILS_ENV=#{rails_env} BACKUP_DIR=#{backup_path}"
    latest = capture("cd #{current_path}; rake -s backup:latest BACKUP_DIR=#{backup_path}").strip
    run "tar -C #{backup_path} -czf #{backup_path}/#{latest}.tar.gz #{latest}"
    get "#{backup_path}/#{latest}.tar.gz", "backups/#{latest}.tar.gz"
    `tar -C backups -zxf backups/#{latest}.tar.gz`
    run "rm #{backup_path}/#{latest}.tar.gz"
    `rm backups/#{latest}.tar.gz`
    `rake backup:restore`
  end
end