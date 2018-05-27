require 'rails_helper'

RSpec.describe LotsController, type: :controller do

  # Testing unsigned user
  describe 'testing lots routes if user didnt signed in' do
    before do
      @current_user = FactoryBot.create(:user)
      @new_lot = FactoryBot.attributes_for(:lot, user: @current_user)
    end

    it 'index lots page is allowed for all users' do
      get :index
      expect(response.status).to eq(200)
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
      @current_user = FactoryBot.create(:user)
      @new_lot = FactoryBot.attributes_for(:lot)
      request.headers.merge! @current_user.create_new_auth_token
    end

    it "get success result after sign_in" do
      expect(response).to be_successful
    end

    it "user can get message is response" do
      get :index
      expect(response.status).to be
    end

    describe "can get /mylots page after sign_in" do
      it "and any your lots didn't exists" do
        get :mylots
        expect(response.status).to eq(204)
      end

      it "and some of your lots already exists" do
        new_lot = FactoryBot.create(:lot, user_id: @current_user.id)
        get :mylots
        expect(response.status).to eq(200)
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
        expect(@current_user.lots.count).to be >0
      end
    end

    # Testing update lots
    describe 'user can update lot' do
      before do
        @new_lot = FactoryBot.create(:lot, user_id: @current_user.id)
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
          request.headers.merge! @current_user.create_new_auth_token
          put :update, params: {:id => @foreign_lot.id, :lot => @foreign_lot, status: :pending}
          expect(response.status).to eq(422)
        end
      end
    end

    #Testing delete lots
    describe 'delete' do
      before do
        @lot = FactoryBot.create(:lot, user: @current_user)
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
end
