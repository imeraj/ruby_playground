require "rails_helper"

RSpec.describe SupportRequestMailer, type: :mailer do
  describe "respond" do
    let(:mail) { SupportRequestMailer.respond }

    it "renders the headers" do
      expect(mail.subject).to eq("Respond")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
