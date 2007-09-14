# Disambiguate URLs by removing trailing slashes
# Idea from http://fleetingideas.com/post/6539239
# This version works with query strings.
module CollectiveIdea #:nodoc:
  module ActionController
    module TrailingSlash #:nodoc:
      def self.included(base) #:nodoc:
        base.before_filter :remove_trailing_slash
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        private
        def remove_trailing_slash
          url = request.url.sub(/(.+)\/(\?.+)?$/, '\1\2')
          if request.request_uri.length > 1 && url != request.url
            headers['Status'] = '301 Moved Permanently'
            redirect_to url and return false
          end
        end
      end
    end
  end
end

# only for edge rails
if ActionController::AbstractRequest.instance_methods.include?('url')
  ActionController::Base.send :include, CollectiveIdea::ActionController::TrailingSlash
end