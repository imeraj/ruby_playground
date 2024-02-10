require 'rails_helper'

RSpec.describe Mutations::CreateUser, type: :request do
  describe ".resolve" do
    let(:user) { build(:user) }
    let(:input) {
      {
        name: user.name,
        auth_provider: {
          credentials: {
            email: user.email,
            password: user.password
          }
        }
      }
    }

    it "creates a new user" do
      expect do
        perform(described_class, input)
      end.to change(User, :count).by(1)
    end

    it "returns the created user" do
      result = GraphqlTutorialSchema.execute(query(user: user), variables: { })
      data = result["data"]["createUser"]

      expect(data["name"]).to eq(user.name)
      expect(data["email"]).to eq(user.email)
      expect(data["id"]).to be_present
    end
  end

  private

  def query(user:)
    <<~GQL
          mutation {
            createUser(
              input: { 
                name: "#{user.name}",
                  authProvider: {
                    credentials: {
                      email: "#{user.email}",
                      password: "#{user.password}"
                    }
                  }
                }
            ) {
              id
              name
              email
            }
          }
        GQL
  end

  def perform(klass, args = {})
    klass.new(object: nil, field: nil, context: {}).resolve(**args)
  end
end


