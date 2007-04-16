
Dir[File.dirname(__FILE__) + "/awesomeness/**/*.rb"].each {|f| require f }

if RAILS_ENV == 'test'
  Dir[File.dirname(__FILE__) + "/test/**/*.rb"].each {|f| require f }
end