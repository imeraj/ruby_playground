my_var = "Success"

MyClass = Class.new do
  p "#{my_var} in the class definition"

  define_method :my_method do
    "#{my_var} in the method definition"
  end
end

p MyClass.new.my_method