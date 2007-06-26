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
        if text.blank?
          ""
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