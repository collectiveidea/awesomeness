# http://dev.rubyonrails.org/ticket/6611
class Test::Unit::TestCase
  
  # Asserts that the given block modifies the specified object or objects.  The default behavior
  # is to test that the value returned by the method or proc is different. It is used by assert_no_difference, 
  # assert_increase and assert_decrease.
  #
  #   assert_difference Group, :count do
  #     post :create, :group => { :name => 'monkeys' }
  #   end
  #
  # You can also check that multiple objects have been modified
  #
  #   assert_increases [ User, Group ], :count do
  #     post :create, :user => { :name => "Curious George" }, :group => { :name => 'monkeys' }
  #   end
  #
  # To test for equality, pass 0 as a difference, or use assert_no_difference.
  #
  # Method or Proc arguments can be passed:
  #
  #   assert_decreases User, [:active_since, 10.minutes.ago] { User.find_trolls.first.destroy }
  # 
  # If the Proc takes arguments, it will be passed the model object first
  #
  #   assert_increases([@model, @model2], Proc.new {|obj| obj.active_since(10.minutes.ago) }) do ...
  # 
  # This implementation is based off of http://blog.caboo.se/articles/2006/06/13/a-better-assert_difference
  def assert_difference(objects, method_and_args, difference = nil)
    objects = [objects] unless objects.is_a? Array

    method_and_args = [method_and_args] unless method_and_args.is_a? Array
    method = method_and_args.shift
    args = method_and_args
    
    initial_values = objects.inject([]) { |sum,obj| sum << method_or_proc(obj, method, args) }
    yield
    clean_backtrace do
      if difference.nil?
        objects.each_with_index { |obj,i|
          assert_not_equal initial_values[i], method_or_proc(obj, method, args), "#{obj}##{method}"
      }
      elsif difference == 0 # allows testing for non-Fixnum equality
        objects.each_with_index { |obj,i|
          assert_equal initial_values[i], method_or_proc(obj, method, args), "#{obj}##{method}"
      }
      else
        objects.each_with_index { |obj,i|
          assert_equal initial_values[i] + difference, method_or_proc(obj, method, args), "#{obj}##{method}"
      }
      end
    end
  end

  # Asserts that the given block does not modify the specified object
  # see assert_difference
  def assert_no_difference(object, method, &block)
    assert_difference object, method, 0, &block
  end
  
  # see assert_difference; by default, verifies the result of the method or proc is increased by 1
  def assert_increases(objects, methods_and_args = :count, difference = 1, &block)
    assert_difference(objects, methods_and_args, difference, &block)
  end

  
  # see assert_difference; by default, verifies the result of the method or proc is decreased by 1
  def assert_decreases(objects, methods_and_args = :count, difference = 1, &block)
    assert_difference(objects, methods_and_args, -difference, &block)
  end

private

  def method_or_proc(obj, method, args)
    return obj.send(method, *args) unless method.is_a?(Proc)
    (method.arity == 0) ? method.call : method.call(obj, *args)
  end
  
end unless respond_to?(:assert_difference)