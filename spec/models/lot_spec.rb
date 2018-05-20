require 'rails_helper'

RSpec.describe Lot, type: :model do

  let(:user) {FactoryBot.create(:user)}

  before do
    @lot = Lot.new(
      title: 'Chili Pepper',
      description: 'Very spicy',
      current_price: 10,
      estimated_price: 75,
      lot_start_time: DateTime.new(2018,6,1,6,30,0),
      lot_end_time: DateTime.new(2018,6,2,8,45,0),
      user_id: user.id
    )
  end

  subject { @lot }

  describe 'lot must have all important attributes' do
    it { should respond_to(:title)}
    it { should respond_to(:description)}
    it { should respond_to(:current_price)}
    it { should respond_to(:estimated_price)}
    it { should respond_to(:lot_start_time)}
    it { should respond_to(:lot_end_time)}
    it { should respond_to(:user_id)}
  end
end
