module Enumerable

  # Divide into groups
  def chunk(number_of_chunks, padding = false)
    returning enum_for(:each_slice, (size.to_f / number_of_chunks).ceil).to_a do |result|
      result << [] while result.length < number_of_chunks
      result.last.pad!(result.first.length, padding) unless padding == false
    end
  end
  alias / chunk
  
end