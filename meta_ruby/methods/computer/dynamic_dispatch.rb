require_relative "./data_source"

class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def cpu
    component :cpu
  end

  def mouse
    component :mouse
  end

  def keyboard
    component :keyboard
  end

  def component(name)
    info = @data_source.send("get_#{name}_info", @id)
    price = @data_source.send("get_#{name}_price", @id)
    result = "#{name.capitalize}: #{info} (#{price})"
    return "* #{result}" if price > 100
    result
  end
end

my_computer = Computer.new(42, DS.new)
p my_computer.cpu
p my_computer.mouse
p my_computer.keyboard
