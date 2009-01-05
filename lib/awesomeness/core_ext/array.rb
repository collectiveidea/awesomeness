class Array
  
  def randomize(limit = length)
    choices = dup
    returning([]) do |result|
      [limit, length].min.times do
        result << choices.delete_at(Kernel.rand(choices.length))
      end
    end.compact
  end
  
  def uniq_with_block!(&block)
    uniq_without_block!
    if block_given?
      grouped = group_by(&block)
      grouped.each do |key,duplicates|
        delete_at(index(duplicates.pop)) while duplicates.size > 1
      end
    end
    self
  end
  alias_method_chain :uniq!, :block
  
  def uniq_with_block(&block)
    dup.uniq!(&block)
  end
  alias_method_chain :uniq, :block
  
  def pad(pad_to_length, padding = nil)
    dup.pad! pad_to_length, padding
  end
  
  def pad!(pad_to_length, padding = nil)
    self << padding while pad_to_length > length
    self
  end

end
