namespace :deploy do
  namespace :apache do
    desc "Start Apache"
    task :start, :roles => :web do
      sudo "/etc/init.d/httpd start > /dev/null"
    end

    desc "Stop Apache"
    task :stop, :roles => :web do
      sudo "/etc/init.d/httpd stop > /dev/null"
    end

    desc "Restart Apache"
    task :restart, :roles => :web do
      sudo "/etc/init.d/httpd restart > /dev/null"
    end
    
    desc "Reload Apache"
    task :reload, :roles => :web do
      sudo "/etc/init.d/httpd reload > /dev/null"
    end
  end
end