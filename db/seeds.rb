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

for i in 2..6 do
  3.times do
    FactoryBot.create(:bid, user: User.find(i + 1), lot: Lot.find(i))
  end
  2.times do
    FactoryBot.create(:bid, user: User.find(i + 2), lot: Lot.find(i))
  end
end