@deploy_require = "require File.join('vendor', 'plugins', 'awesomeness', 'lib', 'recipies')"
@deploy_path = File.join(File.dirname(__FILE__), '..','..', '..', '..', 'config', 'deploy')

def gsub_file(path, regexp, *args, &block)
  content = File.read(path).gsub(regexp, *args, &block)
  File.open(path, 'wb') { |file| file.write(content) }
end