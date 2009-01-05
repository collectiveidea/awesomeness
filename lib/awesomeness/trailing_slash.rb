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
          request_uri = remove_trailing_slash_from(request.request_uri)
          if request.request_uri.length > 1 && request.request_uri != request_uri
            headers['Status'] = '301 Moved Permanently'
            redirect_to request.protocol + request.host_with_port + request_uri and return false
          end
        end
        
        def remove_trailing_slash_from(uri)
          uri.split('?').each{|s| s.sub!(/\/$/, '')}.join('?').sub!(/\A^\/?/, '/\1')
          #uri.sub(/\/(^\?*)?(\?.+)?\/?$/, '/\1\2')#.sub(/\/+/, '/')
        end
      end
    end
  end
end

ActionController::Base.send :include, CollectiveIdea::ActionController::TrailingSlash
