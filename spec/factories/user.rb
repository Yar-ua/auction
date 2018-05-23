FactoryBot.define do
  factory :user do
    email Faker::Internet.unique.email
    password Faker::Internet.unique.password
    phone Faker::PhoneNumber.unique.cell_phone
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    birth_day Faker::Date.birthday min_age = 22
  end
end