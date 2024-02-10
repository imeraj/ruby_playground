require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:purchase) { build(:purchase) }
  let(:saved_purchase) { create(:purchase) }

  it 'generates an access token before saving' do
    @time_now = Time.parse("Apr 28 2016")
    allow(Time).to receive(:now).and_return(@time_now)

    purchase.save
    expect(purchase.idempotency_key).to eq("#{@time_now}/#{purchase.user_id}/#{purchase.book_id}")
  end

  it 'adds the price before saving' do
    purchase.save
    expect(purchase.price).to eq(purchase.book.price)
  end

  describe "#confirm!" do
    before { saved_purchase.confirm!('123') }

    it "saves the charge_id" do
      expect(saved_purchase.charge_id).to eq('123')
    end

    it "confirms the purchase" do
      expect(saved_purchase.status).to eq('confirmed')
    end
  end

  describe "#error!" do
    before { saved_purchase.error!({ "something" => "went_wrong" }) }

    it "registers an error" do
      expect(saved_purchase.error).to eq({ "something" => "went_wrong" })
    end

    it "rejects the purchase" do
      expect(saved_purchase.status).to eq('rejected')
    end
  end
end
