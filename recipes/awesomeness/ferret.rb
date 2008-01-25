
before 'deploy:start',   'deploy:ferret:start'
before 'deploy:stop',    'deploy:ferret:stop'
before 'deploy:restart', 'deploy:ferret:restart'
namespace :deploy do
  namespace :ferret do
    desc "Start the ferret server"
    task :start do
      run "cd #{current_path}; script/ferret_server -e #{fetch(:rails_env, 'production')} start"
    end

    desc "Stop the ferret server"
    task :stop do
      run "cd #{current_path}; script/ferret_server -e #{fetch(:rails_env, 'production')} stop"
    end

    desc "Restart the ferret server"
    task :restart do
      stop
      start
    end
  end
end
