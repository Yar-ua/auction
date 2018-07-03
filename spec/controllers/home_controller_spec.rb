require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  it 'unloggined user can see index page' do
    get :index
    expect(response.status).to eq(200)
  end

  it 'unloggined user cant see about page' do
    get :about
    expect(response.status).to eq(401)
  end

  describe 'loggined user' do
    before do
      login_user
    end

    it 'loggined user cant see about page' do
      get :about
      expect(response.status).to eq(200)
    end
  end
end
