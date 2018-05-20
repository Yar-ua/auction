require 'rails_helper'

RSpec.describe User, type: :model do
  it 'user valid with valid attributes' do
  	user = build(:user)
  	expect(user).to be_valid
  end

  it 'user invalid when some attributes is missing' do
  	user_attrs = attributes_for(:user).except(:email)
  	user = User.new user_attrs
  	expect(user).to be_invalid
  end

  it 'user invalid when some attributes is missing' do
  	user_attrs = attributes_for(:user).except(:birth_day)
  	user = User.new user_attrs
  	expect(user).to be_invalid
  end

  it 'user invalid when email or phone is not unique' do
    create(:user)
    user = build(:user)
    expect(user.save).to be false
  end

  it 'user younger 21' do
    user = create(:user)
    user.birth_day = (Date.today.year - 5)
    expect(user.save).to be false
  end

end