require 'test/unit'
module ActionController
  class AbstractRequest
  end
end
require File.join(File.dirname(__FILE__), '..', 'lib', 'awesomeness', 'trailing_slash')


class TrailingSlashTest < Test::Unit::TestCase
  include CollectiveIdea::ActionController::TrailingSlash::InstanceMethods
  
  def test_remove_without_querystring_1
    assert_equal '/foo', remove_trailing_slash_from('/foo/')
  end
  def test_remove_without_querystring_2
    assert_equal '/foo/bar', remove_trailing_slash_from('/foo/bar/')
  end
  def test_remove_without_querystring_3
    assert_equal '/foo/bar/baz', remove_trailing_slash_from('/foo/bar/baz/')
  end
  def test_remove_without_querystring_4
    assert_equal '/foo/bar/baz.html', remove_trailing_slash_from('/foo/bar/baz.html/')
  end
  
  def test_no_remove_needed_without_querystring_1
    assert_equal '/foo', remove_trailing_slash_from('/foo')
  end
  def test_no_remove_needed_without_querystring_2
    assert_equal '/foo/bar', remove_trailing_slash_from('/foo/bar')
  end
  def test_no_remove_needed_without_querystring_3
    assert_equal '/foo/bar/baz', remove_trailing_slash_from('/foo/bar/baz')
  end
  def test_no_remove_needed_without_querystring_4
    assert_equal '/foo/bar/baz.html', remove_trailing_slash_from('/foo/bar/baz.html')
  end
  
  def test_remove_with_querystring_1
    assert_equal '/foo?bar=baz', remove_trailing_slash_from('/foo/?bar=baz')
  end
  def test_remove_with_querystring_2
    assert_equal '/foo/foo?bar=baz', remove_trailing_slash_from('/foo/foo/?bar=baz')
  end
  def test_remove_with_querystring_3
    assert_equal '/foo/foo?bar=baz', remove_trailing_slash_from('/foo/foo/?bar=baz/')
  end
  
  def test_no_remove_needed_with_querystring_1
    assert_equal '/foo?bar=baz', remove_trailing_slash_from('/foo?bar=baz')
  end
  def test_no_remove_needed_with_querystring_2
    assert_equal '/foo/foo?bar=baz', remove_trailing_slash_from('/foo/foo?bar=baz')
  end
  
  def test_no_remove_needed_with_querystring_without_path
    assert_equal '/?bar=baz', remove_trailing_slash_from('/?bar=baz')    
  end
  
  def test_slash_only
    assert_equal '/', remove_trailing_slash_from('/')
  end
  
  def test_double_slash
    assert_equal '/', remove_trailing_slash_from('//')
  end
end
