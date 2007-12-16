# desc "Explaining what the task does"
# task :awesomeness do
#   # Task goes here
# end

desc 'Rename all .rhtml files in app/views to .erb'
task :rename_all_to_erb do |t|
  Dir.glob('app/views/**/*.rhtml').each do |file|
    puts `svn mv #{file} #{file.gsub(/\.rhtml$/, '.html.erb')}`
  end
end