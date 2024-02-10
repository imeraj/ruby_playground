require 'rails_helper'

RSpec.describe Mutations::CreateLink, type: :request do
  describe ".resolve" do
    let(:link) { build(:link) }
    let(:current_user) { build(:user) }

    it "creates a new link" do
      expect do
        GraphqlTutorialSchema.execute(query(description: link.description, url: link.url),
                                               variables: { }, context: { current_user: current_user})
      end.to change(Link, :count).by(1)
    end

    it "returns the created link" do
      result = GraphqlTutorialSchema.execute(query(description: link.description, url: link.url),
                                             variables: { }, context: { current_user: current_user})
      data = result["data"]["createLink"]

      expect(data["description"]).to eq(link.description)
      expect(data["url"]).to eq(link.url)
      expect(data["id"]).to be_present
    end
  end

  private

  def query(description:, url:)
    <<~GQL
          mutation {
            createLink(
              input: {
                description: "#{description}",
                url: "#{url}"
              } 
            ) {
              id
              description
              url
            }
          }
        GQL
  end
end