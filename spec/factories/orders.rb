FactoryBot.define do
  factory :order do
    association :lot, :factory => :lot
    arrival_location { Faker::Address.full_address }
    arrival_type 0
    arrival_status 0
    
    # trait :pending do
    #   arrival_status 0
    # end

    # trait :sent do
    #   arrival_status 1
    # end

    # trait :delivered do
    #   arrival_status 2
    # end
    
  end

end
