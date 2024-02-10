module StringExtensions
  refine String do
    def reverse
      "eserver"
    end
  end
end

module StringStuff
  using StringExtensions
  p "my_string".reverse
end

p "my_string".reverse