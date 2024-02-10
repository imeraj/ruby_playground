# Preview all emails at http://localhost:3000/rails/mailers/order
class OrderPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order/received
  def received
    order = Order.find(6)
    OrderMailer.received(order)
  end

  # Preview this email at http://localhost:3000/rails/mailers/order/shipped
  def shipped
    order = Order.find(6)
    OrderMailer.shipped(order)
  end

end
