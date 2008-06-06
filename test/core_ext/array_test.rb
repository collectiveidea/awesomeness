require File.dirname(__FILE__) + '/../test_helper'
require 'awesomeness/core_ext/array'

class ArrayTest < Test::Unit::TestCase
  
  def test_pad
    a = [1,2,3]
    assert_equal [1,2,3,nil,nil], a.pad(5)
    assert_equal [1,2,3], a
    assert !a.equal?(a.pad(2))
    assert_equal [1,2,3], a.pad(2)
    assert_equal [1,2,3, 'foo'], a.pad(4, 'foo')
    
    
  end
  
end