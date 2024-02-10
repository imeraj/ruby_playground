require 'rails_helper'

RSpec.describe Mutations::SignInUser, type: :request do
  describe ".resolve" do
    let(:user) { create(:user) }
    let(:valid_params) { {input: { email: user.email, password: user.password } } }

    it "success" do
      result = perform(described_class, valid_params)

      expect(result[:token]).to be_present
      expect(result[:user]).eql?(user)
    end

    it "fails for wrong email" do
      result = perform(described_class, input: { email: 'wrong', password: user.password } )
      expect(result).to be_nil
    end

    it "fails for wrong password" do
      result = perform(described_class, input: { email: user.email, password: 'wrong' } )
      expect(result).to be_nil
    end
  end

  private

  def perform(klass, args = {})
    klass.new(object: nil, field: nil, context: { current_user: user, session: {} }).resolve(**args)
  end
end


