module Enumerable

  # Divide into groups
  def chunk(number_of_chunks, padding = false)
    chunk_size = (size.to_f / number_of_chunks).ceil
    chunk_size = 1 if chunk_size < 1
    returning enum_for(:each_slice, chunk_size).to_a do |result|
      result << [] while result.length < number_of_chunks
      result.last.pad!(result.first.length, padding) unless padding == false
    end
  end
  alias / chunk
  
end