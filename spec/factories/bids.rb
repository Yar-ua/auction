FactoryBot.define do
  factory :bid do
    association :user, :factory => :user
    association :lot, :factory => :lot
    proposed_price {self.lot.current_price + Faker::Commerce.price}
  end

  trait :winner do
    is_winner true
  end
end
