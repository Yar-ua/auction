require 'rails_helper'

RSpec.describe LotsController, type: :controller do

  # Testing unsigned user
  describe 'testing lots routes if user didnt signed in' do
    before do
      @user = FactoryBot.create(:user)
      @new_lot = FactoryBot.attributes_for(:lot, user: @user)
    end

    describe 'index lots page' do
      before do
        get :index
      end

      it 'is allowed for all users' do
        expect(response.status).to eq(200)
      end
    end

    it '/mylots page is unavailable for unregistred users' do
      get :mylots
      expect(response.status).to eq(401)
    end

    it 'POST to create lot must be forbidden' do
      post :create
      expect(response.status).to eq(401)
    end

    it 'PUT to update lot must be forbidden' do
      put :update, params: {id: 0}
      expect(response.status).to eq(401)
    end

    it 'DELETE to destroy lot must be forbidden' do
      delete :destroy, params: {id: 0}
      expect(response.status).to eq(401)
    end

  end

  # Testing, where user just signed in
  describe 'after user signed in' do
    before do
      @user = FactoryBot.create(:user)
      @new_lot = FactoryBot.attributes_for(:lot)
      request.headers.merge! @user.create_new_auth_token
    end

    it "get success result after sign_in" do
      expect(response).to be_successful
    end

    it "user can get message is response" do
      get :index
      expect(response.status).to eq(200)
    end

    describe "GET #lots/mylots can get /lots/mylots page after sign_in" do
      it "you take lots and status-code 200" do
        new_lot = FactoryBot.create(:lot, user_id: @user.id)
        get :mylots
        expect(response.status).to eq(200)
      end

      describe 'test sorting on /lots/mylots' do
        before do
          @user = FactoryBot.create(:user)
          request.headers.merge! @user.create_new_auth_token
          @user_seller = FactoryBot.create(:user)
          10.times do 
            @lot = FactoryBot.create(:lot, user: @user_seller)
            FactoryBot.create(:bid, user: @user, lot: @lot)
          end
        end

        it 'with sort_type: created' do
          get :mylots, params: {filter: :created}
          lot_ids_from_response = JSON.parse(response.body).map { |lot_hash| lot_hash["id"] }
          lot_ids = @user_seller.lots.map { |lot_id| lot_id["id"]}
          expect(lot_ids_from_response).to match_array(lot_ids)
        end

        it 'with sort_type: participation' do
          get :mylots, params: {filter: :participation}
          lot_ids_from_response = JSON.parse(response.body).map { |lot_hash| lot_hash["id"] }
          lot_ids = Lot.joins(:bids).where(bids: { user_id: @user.id }).map { |lot_id| lot_id["id"]}
          expect(lot_ids_from_response).to match_array(lot_ids)
        end

        it 'with sort_type: != participation and != created' do
          get :mylots, params: {filter: :all}
          expect(response.status).to eq(200)
          lot_ids_from_response = JSON.parse(response.body).map { |lot_hash| lot_hash["id"] }
          lot_ids = Lot.left_joins(:bids).where("lots.user_id = ? OR bids.user_id = ?", @user.id, @user.id)
                    .map { |lot_id| lot_id["id"]}
          expect(lot_ids_from_response).to match_array(lot_ids)
        end

      end
    end

    # Testing, where user tried to create lot
    describe 'can create a lot' do
      before do
        post :create, params: @new_lot
      end

      it 'can create lot' do
        expect(response.status).to eq(200)
      end

      it 'lot was created' do
        expect(@user.lots.count).to be >0
      end
    end

    # Testing update lots
    describe 'user can update lot' do
      before do
        @new_lot = FactoryBot.create(:lot, user_id: @user.id)
      end
      
      it 'response is successfull' do
        @new_lot.title = '---Sample test title---'
        put :update, params: {:id => @new_lot.id, :lot => @new_lot, status: :pending}
        expect(response.status).to eq(200)
      end

      it 'but cant if status is not "pending"' do
        @new_lot.in_process!
        put :update, params: {:id => @new_lot.id, :lot => @new_lot, status: :in_process}
        expect(response.status).to eq(422)
      end

      it ' and lot status to in_process' do
        put :update, params: {:id => @new_lot.id, :lot => @new_lot, status: :in_process}
        expect(response.status).to eq(200)
      end

      describe 'but cant update' do
        it 'foreign lot' do
          @foreign_user = FactoryBot.create(:user)
          @foreign_lot = FactoryBot.create(:lot, user: @foreign_user)
          request.headers.merge! @user.create_new_auth_token
          put :update, params: {:id => @foreign_lot.id, :lot => @foreign_lot, status: :pending}
          expect(response.status).to eq(422)
        end
      end
    end

    #Testing delete lots
    describe 'delete' do
      before do
        @lot = FactoryBot.create(:lot, user: @user)
      end

      it 'possible for own lots' do
        delete :destroy, params: {id: @lot.id}
        expect(response.status).to eq(200)
      end

      it 'impossible if lot status is not pending' do
        @lot.in_process!
        delete :destroy, params: {id: @lot.id}
        expect(response.status).to eq(422)
      end

      it 'impossible if you are not lot owner' do
        @foreign_user = FactoryBot.create(:user)
        @foreign_lot = FactoryBot.create(:lot, user: @foreign_user)
        delete :destroy, params: {id: @foreign_lot.id}
        expect(response.status).to eq(422)
      end
    end

  end

  # Test uploading images
  describe "user loginned and upload image" do
    before do
      @user = FactoryBot.create(:user)
      @new_lot = FactoryBot.attributes_for(:lot, :with_image, user: @user)
      request.headers.merge! @user.create_new_auth_token

      post :create, params: @new_lot
    end

    it 'can create lot with image' do
      expect(response.status).to eq(200)
    end

    it 'lot was created' do
      expect(@user.lots.count).to be >0
    end

    it "should uploads image data" do
      expect(@new_lot[:image]).to be
    end

  end


end
