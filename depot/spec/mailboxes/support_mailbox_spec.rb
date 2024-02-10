require 'rails_helper'

RSpec.describe SupportMailbox, type: :mailbox do
  let!(:recent_order) { create(:order, email: "meraj.enigma@gmail.com") }
  let!(:older_order) { create(:order) }

  it "creates a support request when we get a support email" do
    receive_inbound_email_from_mail(
      from: 'meraj.enigma@gmail.com',
      to: 'support@pragstore.com',
      subject: 'Need help',
      body: "I can't figure out how to checkout!"
    )

    support_request = SupportRequest.last
    expect(support_request.email).to eq("meraj.enigma@gmail.com")
    expect(support_request.subject).to eq("Need help")
    expect(support_request.body).to eq("I can't figure out how to checkout!")
    expect(support_request.order_id).to eq(recent_order.id)
  end
end
