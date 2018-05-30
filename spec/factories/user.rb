FactoryBot.define do
  sequence(:email) { |n| "user-#{n}@example.com" }
  sequence(:phone) { |n| "3805011122#{n}" }

  factory :user do
    email
    password { Faker::Internet.unique.password }
    phone
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    birth_day Faker::Date.birthday (DateTime.now.year - 21)
  end

end