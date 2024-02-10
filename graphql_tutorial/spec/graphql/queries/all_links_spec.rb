require 'rails_helper'

RSpec.describe "allLinks", type: :request do
  describe ".resolve" do
    let(:user) { create(:user) }
    let(:link1) { create(:link, description: "test1", url: "http://test1.com", user: user) }
    let(:link2) { create(:link, description: "test2", url: "http://test2.com", user: user) }
    let(:link3) { create(:link, description: "test3", url: "http://test3.com", user: user) }
    let(:link4) { create(:link, description: "test4", url: "http://test4.com", user: user) }
    let!(:links) { [link1, link2, link3, link4] }

    it "returns filtered links" do
      result = find(
        filter: {
          description_contains: 'test1',
          OR: [{
                 url_contains: 'test2',
                 OR: [{
                        url_contains: 'test3'
                      }]
               }, {
                 description_contains: 'test2'
               }]
        }
      )

      expect(result.map(&:description).sort).to match_array([link1, link2, link3].map(&:description).sort)
      expect(result.map(&:url).sort).to match_array([link1, link2, link3].map(&:url).sort)
    end
  end


  private

  def find(args)
    Resolvers::LinksSearch.call(nil, args, nil)
  end
end
