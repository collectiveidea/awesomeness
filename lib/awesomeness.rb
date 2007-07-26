Dir[File.dirname(__FILE__) + "/awesomeness/**/*.rb"].each {|f| require f }

if RAILS_ENV == 'test'
  Dir[File.dirname(__FILE__) + "/test/**/*.rb"].each {|f| require f }
end

# Disambiguate URLs by removing trailing slashes
# Idea from http://fleetingideas.com/post/6539239
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
          if url != request.url
            headers['Status'] = '301 Moved Permanently'
            redirect_to url
          end
        end
      end
    end
  end
end

module ActionView
  module Helpers
    module TextHelper
      
      # Awesome truncate
      # First regex truncates to the length, plus the rest of that word, if any.
      # Second regex removes any trailing whitespace or punctuation (except ;).
      # Unlike the regular truncate method, this avoids the problem with cutting
      # in the middle of an entity ex.: truncate("this &amp; that",9)  => "this &am..."
      # though it will not be the exact length.
      def awesome_truncate(text, length = 30, truncate_string = "…")
        return if text.nil?
        l = length - truncate_string.chars.length
        text.chars.length > length ? text[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : text
      end
      
      # Better versions of standard truncate and excerpt
      def truncate_with_better_default(text, length = 30, truncate_string = "…")
        truncate_without_better_default(text, length, truncate_string)
      end      
      alias_method_chain :truncate, :better_default
      
      def excerpt_with_better_default(text, phrase, radius = 100, excerpt_string = "…")
        excerpt_without_better_default(text, phrase, radius, excerpt_string)
      end
      alias_method_chain :excerpt, :better_default
      
      # Widon't
      # We use this method instead of String#widont directly because textilize is often called with nil.
      # This duplicates textilize's solution of returning the empty string if blank.
      def widont(text)
        if text.blank?
          ''
        else
          text.widont
        end
      end
      
      def textilize_with_widont(text)
        textilize_without_widont widont(text)
      end
      alias_method_chain :textilize, :widont
      
      def textilize_without_paragraph_with_widont(text)
        textilize_without_paragraph_without_widont widont(text)
      end
      alias_method_chain :textilize_without_paragraph, :widont
    end
  end
end