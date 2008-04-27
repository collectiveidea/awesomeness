_cset(:assets) { abort "Please specify assets, set :assets, %w(foo bar)" }

after "deploy:setup", "assets:setup"
after "deploy:update_code", "assets:symlink"

namespace :assets do
  def asset_dirs
    fetch(:assets).map {|dir| File.join(shared_path, 'assets', dir) }
  end
  
  task :setup, :role => :app do
    run "umask 02 && mkdir -p #{asset_dirs.join(' ')}"
  end
  
  task :symlink, :role => :app do
    setup
    fetch(:assets).each do |asset|
      run "rm -f #{release_path}/public/#{asset}"
      run "ln -s #{shared_path}/assets/#{asset} #{release_path}/public/#{asset}"
    end
  end
  
  # FIXME: this is brittle
  task :backup, :role => :app do
    backup_dir = File.expand_path(File.dirname(__FILE__) + '/../../../../public/')
    puts "backing up remote assets to #{backup_dir}"
    puts `rsync -e ssh -qr --delete #{user}@#{roles[:app][0].host}:#{shared_path}/assets/* #{backup_dir}`
  end
  
end