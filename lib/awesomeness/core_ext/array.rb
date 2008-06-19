class Array
  
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
  
  def pad(length, padding = nil)
    returning dup do |a|
      a << padding while length > a.length
    end
  end

end
