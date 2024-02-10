FactoryBot.define do
  factory :product do
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price }
    image_url { "test.jpg" }

    trait :with_line_items do
      after(:create) do |product|
        create_list(:line_item, 1, product: product)
      end
    end
  end

  factory :ruby, class: Product do
    title { "Programming Ruby 1.9" }
    description {
      "Ruby is the fastest growing and most exciting dynamic
      language out there. If you need to get working programs
      delivered fast, you should add Ruby to your toolbox."
    }
    price { 49.50 }
    image_url { "ruby.jpg" }
  end
end