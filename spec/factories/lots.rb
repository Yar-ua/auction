FactoryBot.define do
  factory :lot, class: Lot do
    association :user_id, :factory => :user
    title Faker::Name.title
    description Faker::Name.title
    current_price Faker::Commerce.price
    estimated_price (Faker::Commerce.price * 5)
    lot_start_time (DateTime.now + 4.hours)
    lot_end_time (DateTime.now + 12.hours)
  end
end
