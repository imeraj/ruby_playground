class Integer
  alias_method :old_plus, :+

  def +(value)
    self.old_plus(1).old_plus(1)
  end
end

p 1 + 1