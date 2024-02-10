FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "email_#{n}@gmail.com" }
    sequence(:password) { |n| "secret_#{n}" }
    admin { true }
  end
end