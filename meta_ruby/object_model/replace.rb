class Array
  # class array already has a `replace` method
  def replace(original, replacement)
    self.map {_1 == original ? replacement : _1 }
  end
end

require 'test/unit'

class ArrayExtensionTest < Test::Unit::TestCase
  def test_replace
    original = ['one', 'two', 'one', 'three']
    replaced = original.replace('one', 'zero')
    assert_equal ['zero', 'two', 'zero', 'three'], replaced
  end
end