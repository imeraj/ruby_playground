class Stack
  attr_accessor :elems
  
  def initialize
    @elems = []
  end
  
  def push(elem) 
    elems.push(elem)
  end

  def pop 
    elems.pop
  end
end

arr = gets.chomp
arr = arr.split.map(&:to_i)

stack = Stack.new

arr.each {|elem| stack.push(elem)}

loop do
  elem = stack.pop
  break if elem.nil?

  p elem
end
