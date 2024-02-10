require "rails_helper"

RSpec.describe Product, type: :model do
  let(:valid_product) { create(:product) }
  let(:product_negative_price) { build(:product, price: -1) }
  let(:product_zero_price) { build(:product, price: 0) }
  let(:product_with_line_items) { create(:ruby, line_items: [create(:line_item)]) }

  it 'product attributes must not be empty' do
    product = Product.new
    expect(product).to be_invalid
    expect(product.errors[:title]).to be_present
    expect(product.errors[:description]).to be_present
    expect(product.errors[:price]).to be_present
    expect(product.errors[:image_url]).to be_present
  end

  it "product price must be positive" do
    expect(product_negative_price).to be_invalid
    expect(product_negative_price.errors[:price]).to match_array(["must be greater than or equal to 0.01"])

    expect(product_zero_price).to be_invalid
    expect(product_zero_price.errors[:price]). to match_array(["must be greater than or equal to 0.01"])

    expect(valid_product).to be_valid
  end

  it "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |image_url|
      expect(new_product(image_url)).to be_valid
    end
    bad.each do |image_url|
      expect(new_product(image_url)).to be_invalid
    end
  end

  it "product is not valid without a unique title" do
    product = Product.new(title: valid_product.title, price: 1.0, description: "My Description", image_url: "image.jpg")
    expect(product).to be_invalid
    expect(product.errors[:title]).to match_array(["has already been taken"])
  end

  it "can delete product" do
    product = create(:product)
    expect { product.destroy }.to change { Product.count }.by(-1)
  end

  it "fails to delete product in cart" do
    product = create(:product, :with_line_items)
    expect { product.destroy }.not_to change { LineItem.count }
  end

  private
  def new_product(image_url)
    build(:product, image_url: image_url)
  end
end
