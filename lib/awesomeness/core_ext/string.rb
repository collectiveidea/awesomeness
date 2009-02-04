class String
  # Widon't
  # Based on the original by Shaun Inman: http://shauninman.com/archive/2006/08/22/widont_wordpress_plugin
  # And the Ruby versions here: http://mucur.name/posts/widon-t-helper-for-rails-2
  # This version replaces &nbsp; with a unicode non-breaking space (option-space on a Mac)
  def widont
    self.gsub(/([^\s])\s+([^\s]+)(\s*)$/, '\1 \2\3')
  end
  
  def mb_chars
    chars
  end unless ''.respond_to?(:mb_chars)
end