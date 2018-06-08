FactoryBot.define do
  factory :lot do
    association :user, :factory => :user
    title { Faker::Name.title }
    description { Faker::Name.title }
    current_price { Faker::Commerce.price }
    estimated_price { (current_price + Faker::Commerce.price) }
    lot_start_time { (DateTime.now + 4.hours) }
    lot_end_time (DateTime.now + 12.hours)

    trait :in_process do
      status 1
    end

    trait :closed do
      status 2
    end

    # add image to lot
    trait :with_image do
      image Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, "spec/fixtures/images/ror.png")))
    end

  end
end
