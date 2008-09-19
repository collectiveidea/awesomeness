Dir[File.dirname(__FILE__) + "/awesomeness/**/*.rb"].each {|f| require f }

# From: http://weblog.jamisbuck.org/2007/1/31/more-on-watching-activerecord
# Easy way to view logs in script/console.
# simply type: log_to(STDOUT)
# and all of your active record queries will show up inline.
def log_to(stream = STDOUT)
  ActiveRecord::Base.logger = Logger.new(stream)
  ActiveRecord::Base.clear_active_connections!
end