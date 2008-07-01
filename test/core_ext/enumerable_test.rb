require File.dirname(__FILE__) + '/../test_helper'
require 'awesomeness/core_ext/array'
require 'awesomeness/core_ext/enumerable'

class EnumerableTest < Test::Unit::TestCase
  
  def test_chunk_evenly
    assert_equal [[1], [2], [3]], [1, 2, 3].chunk(3)
  end

  def test_divide_evenly
    assert_equal [[1], [2], [3]], [1, 2, 3] / 3
    assert_equal [[1, 2], [3, 4], [5, 6]], [1, 2, 3, 4, 5, 6].chunk(3)
    assert_equal [[1,2,3,4,5],[6,7,8,9,10]], ((1..10).to_a / 2)
  end

  def test_chunk_unevenly
    assert_equal [[1, 2], [3]], [1, 2, 3].chunk(2)
    assert_equal [[1,2,3,4,5,6,7],[8,9,10,11,12,13]], ((1..13).to_a / 2)
    assert_equal [[1,2,3,4],[5,6,7,8],[9,10]], ((1..10).to_a / 3)
  end

  def test_chunk_fills_with_empty_arrays
    assert_equal [[1], [], []], [1].chunk(3)
  end
  
  def test_chunking_does_not_modify_original
    array = [1, 2, 3]
    assert_equal 3, array.length
    assert_equal [[1], [2], [3]], array.chunk(3)
    assert_equal 3, array.length
  end
  
  def test_chunk_unevenly_with_padding
    assert_equal [[1, 2], [3, nil]], [1, 2, 3].chunk(2, nil)
    assert_equal [[1,2,3,4,5,6,7],[8,9,10,11,12,13, 'foo']], ((1..13).to_a.chunk(2, 'foo'))
  end
  
  def test_divide_by_zero
    assert_equal [[],[]], [].chunk(2)
  end
  
end