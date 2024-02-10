FactoryBot.define do
  factory :link do
    description { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    association :user
  end
end