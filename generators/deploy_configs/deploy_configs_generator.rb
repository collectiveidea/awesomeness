require 'capistrano'
require 'capistrano/cli'

# TODO: error handling. Check if Cap config doesn't exist
class DeployConfigsGenerator < Rails::Generator::Base
  default_options :ports => "8000,8001,8002"
  attr_reader :config
  
  def initialize(runtime_args, runtime_options = {})
    super
    options[:ports] = options[:ports].split(',')
    assign_capistrano_config!
  end
  
  def manifest
    record do |m|
      m.directory "config"
      m.template "logrotate", File.join("config", "logrotate")
      m.template "httpd.conf", File.join("config", "httpd.conf")
    end
  end
  
private

  def assign_capistrano_config!
    @config = Capistrano::Configuration.new
    @config.load Capistrano::CLI::DEFAULT_RECIPES.select {|file| File.exist?(File.join(RAILS_ROOT, file)) }
  end
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--ports ports", "Ports to run mongrel on") do |v|
      options[:ports] = v
    end
  end

end
