FactoryBot.define do
  factory :lot do
    user nil
    # user
    #build(:user, email: 'for@example.com')
    #user[:email] = 'for@example.com'
    #user.phone 0501112233
    # association :user_id, :factory => :user
    # title 'Chili Pepper'
    # description 'Very spicy'
    # current_price 10
    # estimated_price 75
    # lot_start_time DateTime.new(2018,6,1,6,30,0)
    # lot_end_time DateTime.new(2018,6,2,8,45,0)
  end
end
