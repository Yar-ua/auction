require 'rails_helper'

RSpec.describe LotsController, type: :controller do

  describe 'testing lots routes' do
    it 'index lots page is allowed for all users' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'mylots lots page is available' do
      get :mylots
      expect(response.status).to eq(200)
    end
  end

end
