desc "Run migrations and prepare the test database"
task :db => ['db:migrate', 'db:test:prepare']