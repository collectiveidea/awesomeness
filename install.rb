require File.join(File.dirname(__FILE__), 'lib', 'helpers')

gsub_file @deploy_path, /\A\s*(#{Regexp.escape(@deploy_require)}\s*\n)?/mi, "#{@deploy_require}\n"

puts IO.read(File.join(File.dirname(__FILE__), 'README'))