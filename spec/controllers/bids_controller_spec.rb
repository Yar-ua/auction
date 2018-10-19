
require 'rails_helper'

RSpec.describe BidsController, type: :controller do

  describe 'testing bids controller' do
    before do
      @user_seller = FactoryBot.create(:user)
      @lot_pending = FactoryBot.create(:lot, user: @user_seller)
      @lot_closed = FactoryBot.create(:lot, :closed, user: @user_seller)
      @lot = FactoryBot.create(:lot, :in_process, user: @user_seller)
    end

    describe "if not authorized user" do
      it "create action of bids forbidden" do
        get :create, params: {lot_id: @lot.id, proposed_price: 10}
        expect(response).to have_http_status(401)
      end
    end

    describe 'authorised user' do
      before do
        request.headers.merge! @user_seller.create_new_auth_token
      end

      it 'if lot with current id not exists or not finded - exception "Lot not found"' do
        expect {
          post :create, params: {lot_id: 123456, proposed_price: 10}
          }.to raise_error
      end

      describe 'is seller of lot' do
        it 'if user is seller of the lot - he cant create bid' do
          expect {
            post :create, params: {lot_id: @lot.id, proposed_price: 10} 
          }.to raise_error('Lot seller cant create bid')
        end
      end

      describe 'is customer of lot' do
        before do
          login_user
        end

        it 'cant create bid if lot have :pending status' do
          expect {
            post :create, params: {lot_id: @lot_pending.id, 
              proposed_price: (@lot_pending.current_price + 10)}
          }.to raise_error('Forbidden - lot status is not in_process')
        end

        it 'cant create bid if lot have :closed status' do
          expect {
            post :create, params: {lot_id: @lot_pending.id, 
              proposed_price: (@lot_closed.current_price + 10)}
          }.to raise_error('Forbidden - lot status is not in_process')
        end

        it 'if bid have mistakes - response bid errors' do
          @newbid = @user.bids.build(lot_id: @lot.id)
          @newbid.valid?
          post :create, params: {lot_id: @lot.id, user_id: @user.id}
          expect(response.body).to eq(@newbid.errors.messages.to_json)
          expect(response).to have_http_status(403)
        end

        it 'can create bid if lot have :in_process status' do
          post :create, params: {lot_id: @lot.id, 
                proposed_price: (@lot.current_price + 10)}
          expect(response).to have_http_status(200)
        end

      end

    end
  end

end
