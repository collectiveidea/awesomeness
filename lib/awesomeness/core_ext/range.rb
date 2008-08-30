class Range
  
  def include_with_range?(value)
    if value.is_a?(Range)
      self.first <= value.first && 
        (self.exclude_end? && !value.exclude_end? ?
          self.last > value.last :
          self.last >= value.last)
    else
      include_without_range?(value)
    end
  end unless defined?(ActiveSupport::CoreExtensions::Range::IncludeRange)
  alias_method_chain(:include?, :range) unless defined?(ActiveSupport::CoreExtensions::Range::IncludeRange)
  
  def overlap?(range)
    self.include?(range.first) ||
      self.include?(range.exclude_end? ? range.last - 1 : range.last)
  end
  
  alias_method :original_step, :step
  def step(value = 1, &block)
    if block_given?
      original_step(value, &block)
    else
      returning [] do |array|
        original_step(value) {|step| array << step }
      end
    end
  end
  
end