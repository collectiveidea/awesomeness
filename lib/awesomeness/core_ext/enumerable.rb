module Enumerable

  # Divide into groups
  def /(num)
    returning [] do |result|
      each_slice((size.to_f / num).ceil) {|a| result << a }
    end
  end
  
end