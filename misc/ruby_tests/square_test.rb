require_relative './square'
require 'minitest/autorun'

class TestSquare < Minitest::Test
  def test_square_returns_results 
    assert square(10) == 100
  end  
end  

# run with 
# ruby square_test.rb
