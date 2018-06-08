# Creating seeds
10.times do
  user = FactoryBot.create(:user)
  5.times do
    FactoryBot.create(:lot, :in_process, user: user)
  end
  3.times do
    FactoryBot.create(:lot, :closed, user: user)
  end
  3.times do
    FactoryBot.create(:lot, user: user)
  end
end

for i in 1..5 do
  5.times do
    FactoryBot.create(:bid, user: User.find(1), lot: Lot.find(i))
  end
end