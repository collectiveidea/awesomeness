namespace :db do
  namespace :backup do
  
    def backup_directory
      ENV['BACKUP_DIR'] ||= File.join(RAILS_ROOT, 'backups')
    end
  
    task :latest do
      last = Dir["#{backup_directory}/*/"].sort.last
      puts ENV['VERSION'] ||= File.basename(last) if last
    end
  
    task :setup => :environment do
      ENV['VERSION'] ||= Time.now.utc.strftime('%Y%m%d%H%M%S')
      backup = File.join(backup_directory, ENV['VERSION'])
      FileUtils.mkdir_p backup
      ENV['FIXTURES_DIR'] = backup
      ENV['SCHEMA'] = File.join(backup, 'schema.rb')
    end
  
    task :schema => :setup do
      `cp db/schema.rb #{ENV['FIXTURES_DIR']}/`
    end
  
    desc 'Create a new backup of the database'
    task :create => [:setup, 'db:fixtures:dump', 'db:schema:dump']
  
    desc 'Restore a backup of the database. Use VERSION to specify a version other than the latest.'
    task :restore => [:latest, :setup, 'db:schema:load', 'db:fixtures:load']
  end
end