# http://matthewbass.com/2007/03/07/overriding-existing-rake-tasks/
Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end
 
def remove_task(task_name)
  Rake.application.remove_task(task_name)
end

remove_task "db:fixtures:load"
remove_task "db:fixtures:dump"

namespace :db do  
  namespace :fixtures do
    desc "Load fixtures into the current environment's database.  Load specific fixtures using FIXTURES=x,y"
    task :load => :environment do
      require 'active_record/fixtures'
      fixtures_dir = ENV['FIXTURES_DIR'] || 'test/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(fixtures_dir, '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures(fixtures_dir, File.basename(fixture_file, '.*'))
      end
    end
    
    desc "Create YAML fixtures from data in the current environment's database. Dump specific tables using TABLES=x[,y,z]."
    task :dump => :environment do
      skip_tables = ["schema_info", "sessions"] 
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      fixtures_dir = ENV['FIXTURES_DIR'] || 'test/fixtures'
      tables = ENV['TABLES'] || ActiveRecord::Base.connection.tables
      sql = "SELECT * FROM %s LIMIT %d OFFSET %d"
      limit = 50
      (tables - skip_tables).each do |table_name| 
        i = "000"
        offset = 0
        File.open("#{fixtures_dir}/#{table_name}.yml", 'w' ) do |file|
          while !(data = ActiveRecord::Base.connection.select_all(sql % [table_name, limit, offset])).empty?
            data.each do |record|
              file.write({"#{table_name}_#{i.succ!}" => record}.to_yaml.gsub(/^---.*\n/, ''))
            end
            offset += limit
          end
        end
      end
    end
  end
end
