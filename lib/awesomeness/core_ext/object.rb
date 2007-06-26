class Object
  # See http://moonbase.rydia.net/mental/blog/programming/eavesdropping-on-expressions
  # Will be added in Ruby 1.9
  def tap
    yield self
    self
  end if RUBY_VERSION < '1.9'
end