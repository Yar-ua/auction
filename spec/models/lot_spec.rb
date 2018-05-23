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
    it { should respond_to(:title)}
    it { should respond_to(:description)}
    it { should respond_to(:current_price)}
    it { should respond_to(:estimated_price)}
    it { should respond_to(:lot_start_time)}
    it { should respond_to(:lot_end_time)}
    it { should respond_to(:user_id)}
  end

  it 'Lot is valid with valid attributes' do
    expect(lot).to be_valid
  end

  it 'Lot is valid with valid attributes' do
    lot_attrs = attributes_for(:lot).except(:user_id)
    new_lot = Lot.new lot_attrs
    expect(new_lot).to be_invalid
  end
end
