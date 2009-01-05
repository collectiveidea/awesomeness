require File.dirname(__FILE__) + '/../test_helper'
require 'awesomeness/core_ext/array'

class ArrayTest < Test::Unit::TestCase
  
  def test_pad
    a = [1,2,3]
    assert_equal [1,2,3,nil,nil], a.pad(5)
  end
  
  def test_pad_does_not_exceed_length
    a = [1,2,3]
    assert_equal a, a.pad(2)
    assert_equal a, a.pad(3)
  end
  
  def test_pad_with_custom_padding
    a = [1,2,3]
    assert_equal [1,2,3,'foo'], a.pad(4, 'foo')
  end
  
  def test_pad_does_not_modify_original
    a = [1,2,3]
    a.pad(4)
    assert_equal 3, a.length
  end
  
  def test_pad_does_not_modify_original
    a = [1,2,3]
    a.pad(4)
    assert_equal 3, a.length
  end
  
  def test_pad!
    a = [1,2,3]
    a.pad!(4, 'x')
    assert_equal [1,2,3,'x'], a
  end
  
  def test_randomize_length
    assert_equal 4, (1..10).to_a.randomize(4).length
  end
  
  def test_randomize_with_fewer_options
    a = [1,2,3]
    assert_equal 3, a.randomize(10).length
  end
end