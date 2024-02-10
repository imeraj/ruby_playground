require_relative './factorial'

describe 'factorial' do
  it 'returns 1 when given 0' do
    expect(factorial(0)).to eq(1)
  end

  it 'returns 1 when given 1' do
    expect(factorial(1)).to eq(1)
  end

  it 'returns factorial of given numbers' do
    expect(factorial(5)).to eq(120)
    expect(factorial(6)).to eq(720)
  end  
end

# run with
# rspec factorial_spec.rb
