before "deploy:migrate", "backup"

desc "Backup the remote production database"
task :backup, :roles => :db, :only => { :primary => true } do
  require 'yaml'
  
  filename = "#{application}.dump.#{Time.now.to_i}.sql.bz2"
  tmpfile = "/tmp/#{filename}"
  delete_command = "rm -f #{tmpfile}"
  on_rollback { run delete_command }
  db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'database.yml'))).result)['production']
  host = db['host'] ? "-h #{db['host']}" : ''
  
  run "mysqldump #{host} -u #{db['username']} --password=#{db['password']} #{db['database']} | bzip2 -c > #{tmpfile}"  do |ch, stream, out|
    puts out
  end
  `mkdir -p #{File.dirname(__FILE__)}/../../../../backups/`
  get tmpfile, "backups/#{filename}"
  run delete_command
end
