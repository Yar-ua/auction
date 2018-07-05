FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.unique.password }
    phone { Faker::PhoneNumber.cell_phone }
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    birth_day Faker::Date.birthday (DateTime.now.year - 21)
  end

end