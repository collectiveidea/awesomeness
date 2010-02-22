require 'test/unit'
require 'rubygems'
require 'action_view'
require File.join(File.dirname(__FILE__), '..', 'lib', 'awesomeness', 'text_helper')


class TextHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::TextHelper
  
  def test_awesome_truncate_with_nil
    assert_nil awesome_truncate(nil)
  end
  
  def test_awesome_truncate_with_blank
    assert_equal '', awesome_truncate('')
  end
  
  def test_awesome_truncate
    assert_equal 'foo...', awesome_truncate('foo bar baz', 5, '...')
  end
  
  def test_awesome_truncate_with_sentence
    assert_equal 'foo bar...', awesome_truncate('foo bar. baz', 8, '...')
  end
  
  # TODO: this would be sweet
  # def test_awesome_truncate_with_html
  #     assert_equal 'foo...', awesome_truncate('foo <img src="bar.png">', 8, '...')
  #   end
end