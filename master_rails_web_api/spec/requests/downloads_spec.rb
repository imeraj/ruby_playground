require "rails_helper"

RSpec.describe "Access Tokens", type: :request do
  include_context 'Skip Auth'

  let(:book) { create(:book, download_url: "https://example.com/book.pdf") }

  describe "GET /api/books/:book_id/download" do
    context "with an existing book" do
      before { get "/api/books/#{book.id}/download" }

      it { expect(response.status).to eq(204) }
      it { expect(response.headers['Location']).to eq(book.download_url) }
    end

    context "with a non-existing book" do
      it "returns a 404" do
        get "/api/books/999999999/download"
        expect(response.status).to eq(404)
      end
    end

  end
end