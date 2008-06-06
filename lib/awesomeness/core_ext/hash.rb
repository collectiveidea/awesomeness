class Hash
  # Usage {:a => [1,3,4], :b => [2,5]}.without(:a => 1)
  # returns {:a => [3,4], :b => [2,5]}
  def without(hash)
    hash = hash.with_indifferent_access if self.instance_of?(HashWithIndifferentAccess)
    # create a new hash using this class, so we get a new HashWithIndifferentAccess if this is one
    inject(self.class.new) do |result,(k,v)|
      result[k] = (hash[k] && v.respond_to?(:reject) ? v.reject {|v,_| v == hash[k] } : v)
      result
    end
  end
  
  def compact!
    delete_if { |k,v| v.blank? }
  end
  
  def compact
    dup.compact!
  end
end