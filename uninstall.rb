require File.join(File.dirname(__FILE__), 'lib', 'helpers')

gsub_file @deploy_path, /\A\s*(#{Regexp.escape(@deploy_require)}\s*\n)?/mi, ''
