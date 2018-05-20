# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creating users
User.find_or_create_by! email: 'hulk@gmail.com' do |user|
  user.email = 'hulk@gmail.com'
  user.password = 'qwerqwer'
  user.phone = '0671112233'
  user.first_name = 'Hulk'
  user.last_name = 'Bogan'
  user.birth_day = '1950'
end

User.find_or_create_by! email: 'boris@gmail.com' do |user|
  user.email = 'boris@gmail.com'
  user.password = 'asdfasdf'
  user.phone = '0509998877'
  user.first_name = 'Boris'
  user.last_name = 'The Razor'
  user.birth_day = '1970'
end

# Creating lots
Lot.find_or_create_by!(
  title: 'Chili Pepper',
  description: 'Very spicy',
  current_price: 10,
  estimated_price: 75,
  lot_start_time: DateTime.new(2018,6,1,6,30,0),
  lot_end_time: DateTime.new(2018,6,2,8,45,0),
  user_id: 1
)

Lot.find_or_create_by!(
  title: 'Supercarrier "Gerald Ford"',
  description: 'sale with 50 planes and helicopters onboard',
  current_price: 350000000,
  estimated_price: 650000000,
  lot_start_time: DateTime.new(2018,6,1,6,30,0),
  lot_end_time: DateTime.new(2018,8,2,8,45,0),
  user_id: 1
)

Lot.find_or_create_by!(
  title: 'Nescafe coffee',
  description: 'big box with 50 packages',
  current_price: 20,
  estimated_price: 40,
  lot_start_time: DateTime.new(2018,6,1,10,00,0),
  lot_end_time: DateTime.new(2018,6,4,11,45,0),
  user_id: 2
)