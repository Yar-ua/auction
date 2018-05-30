# Creating seeds
10.times do
  user = FactoryBot.create(:user)
  5.times do
    FactoryBot.create(:lot, user: user)
  end
end
