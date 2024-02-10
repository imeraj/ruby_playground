def a_method(a, b)
  a + yield(a, b)
end

p a_method(1, 2) { |x, y| (x + y) * 3}

def a_method
  return yield if block_given?
  'no block'
end

p a_method
p a_method { "here's a block" }