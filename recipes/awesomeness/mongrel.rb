set :mongrel_servers, 2
set :mongrel_port, 8000
set :mongrel_address, "127.0.0.1"
set :mongrel_environment, "production"
set :mongrel_conf, nil
set :mongrel_user, nil
set :mongrel_group, nil
set :mongrel_prefix, nil
set :mongrel_rails, 'mongrel_rails'
set :mongrel_clean, true
set :mongrel_pid_file, nil
set :mongrel_log_file, nil
set :mongrel_config_script, nil
def set_mongrel_conf
  set :mongrel_conf, "/etc/mongrel_cluster/#{application}.yml" unless mongrel_conf
end

namespace :deploy do
  
  namespace :mongrel do
    
    desc "Configure Mongrel processes on the app server."
    task :configure, :roles => :app do
      set_mongrel_conf

      argv = []
      argv << "#{mongrel_rails} cluster::configure"
      argv << "-N #{mongrel_servers.to_s}"
      argv << "-p #{mongrel_port.to_s}"
      argv << "-e #{mongrel_environment}"
      argv << "-a #{mongrel_address}"
      argv << "-c #{current_path}"
      argv << "-C #{mongrel_conf}"
      argv << "-P #{mongrel_pid_file}" if mongrel_pid_file
      argv << "-l #{mongrel_log_file}" if mongrel_log_file
      argv << "--user #{mongrel_user}" if mongrel_user
      argv << "--group #{mongrel_group}" if mongrel_group
      argv << "--prefix #{mongrel_prefix}" if mongrel_prefix
      argv << "-S #{mongrel_config_script}" if mongrel_config_script
      cmd = argv.join " "
      invoke_command cmd, :via => run_method
    end
    
    desc "Check the status of the Mongrel processes"
    task :status, :roles => :app do
      set_mongrel_conf
      invoke_command "#{mongrel_rails} cluster::status -C #{mongrel_conf}", :via => run_method
    end

    [:stop, :start, :restart].each do |t|
      desc "#{t.to_s.capitalize} the mongrel cluster"
      task t, :roles => :app do
        set_mongrel_conf
        cmd = "#{mongrel_rails} cluster::#{t} -C #{mongrel_conf}"
        cmd += " --clean" if mongrel_clean    
        invoke_command cmd, :via => run_method
      end
    end
  end
  
  # override default deploy tasks
  [:stop, :start, :restart].each do |t|
    desc "#{t.to_s.capitalize} the mongrel cluster"
    task t, :roles => :app do
      deploy.mongrel.send(t)
    end
  end
  
end