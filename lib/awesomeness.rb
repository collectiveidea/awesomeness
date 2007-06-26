
Dir[File.dirname(__FILE__) + "/awesomeness/**/*.rb"].each {|f| require f }

if RAILS_ENV == 'test'
  Dir[File.dirname(__FILE__) + "/test/**/*.rb"].each {|f| require f }
end


module ActionView
  module Helpers
    module TextHelper
      
      def truncate_with_better_default(text, length = 30, truncate_string = "…")
        truncate_without_better_default(text, length, truncate_string)
      end
      
      alias_method_chain :truncate, :better_default
      
      def excerpt_with_better_default(text, phrase, radius = 100, excerpt_string = "…")
        excerpt_without_better_default(text, phrase, radius, excerpt_string)
      end
      
      alias_method_chain :excerpt, :better_default
      
      # Widon't
      def widont(text)
        text.widont
      end
      
      def textilize_with_widont(text)
        textilize_without_widont(text.widont)
      end
      alias_method_chain :textilize, :widont
      
      def textilize_without_paragraph_with_widont(text)
        textilize_without_paragraph_without_widont(text.widont)
      end
      alias_method_chain :textilize_without_paragraph, :widont
    end
  end
end

class String
  # Widon't
  # Based on the original by Shaun Inman: http://shauninman.com/archive/2006/08/22/widont_wordpress_plugin
  # And the Ruby versions here: http://mucur.name/posts/widon-t-helper-for-rails-2
  # This version replaces &nbsp; with a unicode non-breaking space (option-space on a Mac)
  def widont
    self.gsub(/([^\s])\s+([^\s]+)(\s*)$/, '\1 \2\3')
  end
end