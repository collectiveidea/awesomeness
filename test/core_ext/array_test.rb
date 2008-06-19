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
  
  def test_divide
    assert_equal [[1,2,3,4,5],[6,7,8,9,10]], ((1..10).to_a / 2)
    assert_equal [[1,2,3,4],[5,6,7,8],[9,10]], ((1..10).to_a / 3)
    assert_equal [[1,2,3,4,5,6,7],[8,9,10,11,12,13]], ((1..13).to_a / 2)
  end
  
end