namespace :backup do
  def latest_version
    last = Dir['backups/*.tar.gz'].sort.last
    File.basename(last, '.tar.gz') if last
  end
  
  task :environment do
    backup = "backups/#{ENV['VERSION'] || latest_version}"
    `tar -C backups -zxf #{backup}.tar.gz` unless File.exist?(backup)
    ENV['FIXTURES_DIR'] = "#{backup}"
    ENV['SCHEMA'] = "#{backup}/schema.rb"
  end
  
  task :restore => [:environment, 'db:schema:load', 'db:fixtures:load']
end
