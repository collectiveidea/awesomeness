require File.dirname(__FILE__) + '/../test_helper'
require 'awesomeness/core_ext/enumerable'

class EnumerableTest < Test::Unit::TestCase
  
  def test_divide
    assert_equal [[1,2,3,4,5],[6,7,8,9,10]], ((1..10).to_a / 2)
    assert_equal [[1,2,3,4],[5,6,7,8],[9,10]], ((1..10).to_a / 3)
    assert_equal [[1,2,3,4,5,6,7],[8,9,10,11,12,13]], ((1..13).to_a / 2)
    # assert_equal([[[:a, 1], [:b, 2]], [[:c, 3]]], {:a => 1, :b => 2, :c => 3} / 2)
  end
  
end