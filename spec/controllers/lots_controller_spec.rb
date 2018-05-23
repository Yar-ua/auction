require 'rails_helper'

RSpec.describe LotsController, type: :controller do

  describe 'testing lots routes if user didnt signed in' do
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

    describe 'after user signed in' do
      before do
        @current_user = FactoryBot.create(:user)
        @lot = FactoryBot.create(:lot)
        request.headers.merge! @current_user.create_new_auth_token
      end

      it "can get /mylots page after sign_in" do
        get :mylots
        expect(response.status).to eq(200)
      end

      it "user can get message is response" do
        get :index
        expect(JSON.parse(response.body)["message"]).to be
      end

      it 'can create lot' do
        post :create, params: @lot
        expect(response.status).to eq(200)
      end

    end

  end

end
