namespace :deploy do
  [ :stop, :start, :restart ].each do |t|
    desc "#{t.to_s.capitalize} the mongrel cluster"
    task t, :roles => :app do
      run "mongrel_rails cluster::#{t.to_s} --clean -C #{mongrel_conf}"
    end
  end
end