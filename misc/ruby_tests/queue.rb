arr = gets.chomp
arr = arr.split.map(&:to_i)

queue = Queue.new

arr.each {|elem| queue.push(elem)}

while queue.size.nonzero?
  p queue.pop
end
