namespace :backup do
  
  task :directory do
    ENV['BACKUP_DIR'] ||= 'backups'
  end
  
  task :latest => :directory do
    last = Dir["#{ENV['BACKUP_DIR']}/*/"].sort.last
    puts ENV['VERSION'] ||= File.basename(last) if last
  end
  
  task :environment => :directory do
    ENV['VERSION'] ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
    backup = "#{ENV['BACKUP_DIR']}/#{ENV['VERSION']}"
    FileUtils.mkdir_p backup
    ENV['FIXTURES_DIR'] = backup
    ENV['SCHEMA'] = "#{backup}/schema.rb"
  end
  
  task :schema => :environment do
    `cp db/schema.rb #{ENV['FIXTURES_DIR']}/`
  end
  
  desc "Create a new backup of the database"
  task :create => [:environment, 'db:fixtures:dump', 'db:schema:dump']
  
  desc "Restore a backup of the database. Use VERSION to specify a version other than the latest."
  task :restore => [:latest, :environment, 'db:schema:load', 'db:fixtures:load']
end
