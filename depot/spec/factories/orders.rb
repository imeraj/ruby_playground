FactoryBot.define do
  factory :order do
    name { Faker::Name.name }
    address { "MyText" }
    email { Faker::Internet.email }
    pay_type { "Check" }
  end
end
