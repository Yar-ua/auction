require 'rails_helper'

RSpec.describe BidsController, type: :controller do

  describe 'testing bids controller' do
    before do
      @user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, :in_process, user: @user)
      @bid = FactoryBot.create(:bid, user: @user, lot: @lot)
    end

    describe "if not authorized user" do
      it "create action of bids forbidden" do
        #get :create
        get :create, params: {lot_id: 1, proposed_price: 10}
        expect(response).to have_http_status(401)
      end
    end

    describe 'authorised user' do
      before do
        request.headers.merge! @user.create_new_auth_token
      end

      it 'can create bid' do
        post :create, params: {lot_id: @lot.id, proposed_price: 10}
        expect(response).to have_http_status(200)
      end
    end
  end

end
