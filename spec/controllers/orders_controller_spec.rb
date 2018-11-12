require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  before do
    @seller = FactoryBot.create(:user)
    @customer = FactoryBot.create(:user)
    @lot = FactoryBot.create(:lot, :in_process, user: @seller)
    @bid = FactoryBot.create(:bid, user: @customer, lot: @lot, proposed_price: @lot.estimated_price + 1)
    @order = FactoryBot.build(:order, lot: @lot)
  end

  describe 'testing lots routes if user didnt signed in' do
    it 'order#create is unavailable for unregistred users' do
      post :create, params: {lot_id: @lot.id}
      expect(response.status).to eq(401)
    end

    it 'order#sent is unavailable for unregistred users' do
      post :sent, params: {lot_id: @lot.id}
      expect(response.status).to eq(401)
    end

    it 'order#delivered is unavailable for unregistred users' do
      post :delivered, params: {lot_id: @lot.id}
      expect(response.status).to eq(401)
    end
  end

  describe 'user can create order' do
    it 'but cant if not customer' do
      authenticate_user @seller
      expect{ post :create, params: {lot_id: @lot.id} }.to raise_error('Forbidden! Only customer can change this status')
    end

    it 'if user is customer' do
      authenticate_user @customer
      post :create, params: {lot_id: @lot.id, arrival_type: @order.arrival_type, arrival_location: @order.arrival_location}
      expect(response.status).to eq(200)
    end
  end

  describe 'user can change order status to sent' do
    it 'but cant if user is not seller' do
      authenticate_user @customer
      expect{ put :sent, params: {lot_id: @lot.id} }.to raise_error('Forbidden! Only seller can change this status')
    end

    it 'if user is seller' do
      authenticate_user @seller
      expect(response.status).to eq(200)
    end
  end

  describe 'user can change order status to delivered' do
    it 'but cant if user is not customer' do
      authenticate_user @seller
      expect{ put :delivered, params: {lot_id: @lot.id} }.to raise_error('Forbidden! Only customer can change this status')
    end

    it 'if user is seller' do
      authenticate_user @customer
      expect(response.status).to eq(200)
    end
  end

end
