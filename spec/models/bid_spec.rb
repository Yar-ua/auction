require 'rails_helper'

RSpec.describe Bid, type: :model do

  describe 'testing bid model' do

    before do
      @user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, :in_process, user: @user)
      @bid = FactoryBot.create(:bid, user: @user, lot: @lot, proposed_price: @lot.current_price + 1)
    end

    it 'proposed_price cant be less than 0' do
      @bid.proposed_price = -10
      expect(@bid).to be_invalid
    end

    it 'proposed_price must be more than 0' do
      @bid.proposed_price = 0.01
      expect(@bid).to be_valid
    end

    it 'proposed_price must be exist' do
      @bid.proposed_price = nil
      expect(@bid).to be_invalid
    end

    describe 'test :proposed_price_is_valid validation' do
      it 'when current_price >= proposed_price' do
        @bid.proposed_price = @lot.current_price - 10
        expect(@bid.proposed_price_is_valid).to be false
        @bid.proposed_price = @lot.current_price
        expect(@bid.proposed_price_is_valid).to be false
      end

      it 'when current_price >= proposed_price' do
        @bid.proposed_price = @lot.current_price + 1
        expect(@bid.proposed_price_is_valid).to be true
      end
    end

    describe 'test update lot.current_price' do
      it 'when new bid created' do
        @bid.proposed_price = @lot.current_price + 5
        @bid.update_lot_current_price
        expect(@bid.proposed_price).to eq(@lot.current_price)
      end
    end

    describe 'test if proposed_price in bid' do

      describe 'is not winning proposition' do
        before do
          @bid = FactoryBot.create(:bid, user: @user, lot: @lot, 
                            proposed_price: @lot.estimated_price - 1)
          @bid.check_is_winner
        end

        it 'not change :is_winner status' do
          expect(@bid.is_winner).to be false
        end

        it 'lot must have status :in_process' do
          expect(@lot.status).to eq('in_process')
        end
      end

      describe 'is winning proposition' do
        before do
          @bid = FactoryBot.create(:bid, user: @user, lot: @lot, 
                            proposed_price: @lot.estimated_price + 1)
          @bid.check_is_winner
        end

        it 'change :is_winner status if bid is winner' do
          expect(@bid.is_winner).to be true
        end

        it 'lot must change status to :closed' do
          expect(@lot.status).to eq('closed')
        end
      end

    end

  end

end
