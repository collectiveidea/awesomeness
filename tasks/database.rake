# These tasks replace the built-in Rails tasks for dumping and loading the schema,
# allowing you to specify the FIXTURES_DIR to use for dumping and loading.
Rake.application.instance_eval do
  @tasks.delete "db:fixtures:load"
  @tasks.delete "db:fixtures:dump"
end


namespace :db do  
  namespace :fixtures do
    desc "Load fixtures into the current environment's database.  Load specific fixtures using FIXTURES=x,y"
    task :load => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      fixtures_dir = ENV['FIXTURES_DIR'] || File.join(RAILS_ROOT, 'test', 'fixtures')
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(fixtures_dir, '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures(fixtures_dir, File.basename(fixture_file, '.*'))
      end
    end
    
    desc "Create YAML fixtures from data in the current environment's database. Dump specific tables using TABLES=x[,y,z]."
    task :dump => :environment do
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      fixtures_dir = ENV['FIXTURES_DIR'] || 
         File.join(RAILS_ROOT, 'test', 'fixtures')
      skip_tables = ENV['SKIP_TABLES'] ? ENV['SKIP_TABLES'].split(/,/) : ["sessions"]
      tables = ENV['TABLES'] ? ENV['TABLES'].split(/,/) : ActiveRecord::Base.connection.tables
      sql = "SELECT * FROM %s LIMIT %d OFFSET %d"
      limit = 500
      (tables - skip_tables).each do |table_name| 
        i = "000"
        offset = 0
        File.open("#{fixtures_dir}/#{table_name}.yml", 'w' ) do |file|
          while !(data = ActiveRecord::Base.connection.select_all(sql % [table_name, limit, offset])).empty?
            data.each do |record|
              file.write({"#{table_name}_#{i.succ!}" => record}.to_yaml.sub(/^---.*\n/, ''))
            end
            offset += limit
          end
        end
      end
    end
  end
end
