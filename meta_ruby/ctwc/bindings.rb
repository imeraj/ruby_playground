class MyClass
  def my_method
    @x = 1
    binding
  end
end

p b = MyClass.new.my_method

p eval "@x", b