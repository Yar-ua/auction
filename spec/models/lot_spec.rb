require 'rails_helper'

RSpec.describe Lot, type: :model do

  let(:user) {FactoryBot.create(:user)}

  let(:lot) {FactoryBot.create(:lot, :user_id => user.id)}

  it 'user after Factory valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'lot after Factory valid with valid attributes' do
    expect(lot).to be_valid
  end

  subject { lot }

  describe 'lot must have all important attributes' do
    it { expect(:title).to be}
    it { expect(:description).to be}
    it { expect(:current_price).to be}
    it { expect(:estimated_price).to be}
    it { expect(:lot_start_time).to be}
    it { expect(:lot_end_time).to be}
    it { expect(:user_id).to be}
  end

  it 'Lot is valid with valid attributes' do
    expect(lot).to be_valid
  end

  describe 'Lots price:' do

    it 'lot current_price cant be less 0' do
      lot.estimated_price = -5
      expect(lot).to be_invalid
    end

    it 'lot estimated_price cant be less 0' do
      lot.current_price = -0.1
      expect(lot).to be_invalid
    end
  end

  describe 'Lot is' do
    it 'invalid if lot_start_time is after lot_end_time' do
      lot.lot_start_time = DateTime.now
      lot.lot_end_time = DateTime.now - 1.second
      expect(lot).to be_invalid
    end

    it 'valid if lot_start_time is before lot_end_time' do
      lot.lot_start_time = DateTime.now
      lot.lot_end_time = DateTime.now + 1.second
      expect(lot).to be_valid
    end

    it 'Lot is invalid without :user_id' do
      lot_attrs = attributes_for(:lot).except(:user_id)
      new_lot = Lot.new lot_attrs
      expect(new_lot).to be_invalid
    end
  end

end
