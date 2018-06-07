require 'rails_helper'

RSpec.describe Bid, type: :model do

  describe 'testing bid model' do

    before do
      @user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, :in_process, user: @user)
      @bid = FactoryBot.create(:bid, user: @user, lot: @lot)
    end

    it 'proposed_price cant be less than 0' do
      @bid.proposed_price = -10
      expect(@bid).to be_invalid
    end

    it 'proposed_price must be more than 0' do
      @bid.proposed_price = 0.01
      expect(@bid).to be_valid
    end
  end

end
