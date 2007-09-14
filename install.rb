load_tasks = <<-EOF
load_paths.unshift File.expand_path(File.dirname(__FILE__) + '/../vendor/plugins/awesomeness/recipies')
load 'awesomeness'

EOF

deploy_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'config', 'deploy.rb')

content = load_tasks + File.read(deploy_path)
File.open(deploy_path, 'wb') {|file| file.write(content) }

puts IO.read(File.join(File.dirname(__FILE__), 'README'))