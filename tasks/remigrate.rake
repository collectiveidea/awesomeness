namespace :db do
  desc "Run down and up for the latest migration"
  task :remigrate => :environment do
    ActiveRecord::Migrator.down("db/migrate/", ActiveRecord::Migrator.current_version - 1)
    ActiveRecord::Migrator.up("db/migrate/", ActiveRecord::Migrator.current_version + 1)
    Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end
end