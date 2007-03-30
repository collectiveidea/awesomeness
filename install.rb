@deploy_require = "require File.join('vendor', 'plugins', 'awesomeness', 'lib', 'recipies')"
@deploy_path = File.join(File.dirname(__FILE__), '..','..', '..', '..', 'config', 'deploy.rb')

def gsub_file(path, regexp, *args, &block)
  content = File.read(path).gsub(regexp, *args, &block)
  File.open(path, 'wb') { |file| file.write(content) }
end

gsub_file @deploy_path, /\A\s*(#{Regexp.escape(@deploy_require)}\s*\n)?/mi, "#{@deploy_require}\n"

puts IO.read(File.join(File.dirname(__FILE__), 'README'))