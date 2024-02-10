require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  describe "received" do
    let(:order) { create(:order) }
    let(:mail) { OrderMailer.received(order) }

    it "renders the headers" do
      expect(mail.subject).to eq("Pragmatic Store Order Confirmation")
      expect(mail.to).to eq([order.email])
      expect(mail.from).to eq(["pragma@store.com"])
    end

    it "renders the body" do
      expect(mail.body).to match(/We have received the order #{order.id}/)
    end
  end
end
