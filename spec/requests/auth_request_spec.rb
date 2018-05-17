require "rails_helper"

# Resource: https://github.com/lynndylanhurley/devise_token_auth/issues/75#issuecomment-258496229

RSpec.describe "Auth", :type => :request do
  before do
    phone = '0672223344'
    email = 'foo@bar.com'
    password = 'quxbarfoo'
    first_name = 'Firsr name'
    last_name = 'Last name'
    birth_day = 1981
    @sign_in_params = {
      email: email,
      password: password
    }
    @registration_params = {
      phone: phone,
      email: email,
      password: password,
      first_name: 'Firsr name',
      last_name: 'Last name',
      birth_day: 1981
    }
  end

  describe 'Testing registration: POST /auth' do
    it 'should respond with 200 OK' do
      post user_registration_path @registration_params
      expect(response).to be_success 
    end

    it 'should increase user count by 1' do
      expect{
        post user_registration_path @registration_params
      }.to change(User, :count).by(1)
    end
  end

  describe 'Testing confirm registration: GET /auth/confirmation' do
    before do
      post user_registration_path @registration_params
      @user = User.last
    end

    it 'should respond with 301 REDIRECTION' do
      get user_confirmation_path(:config => 'default', :confirmation_token => @user.confirmation_token, :redirect_url => '/')
      expect(response).to be_redirect
    end
  end

  describe 'Testing login: POST /auth/sign_in' do
    before do
      post user_registration_path @registration_params
      user = User.last
      get user_confirmation_path(:config => 'default', :confirmation_token => user.confirmation_token, :redirect_url => '/')
    end

    it 'should respond with 200 OK' do
      post user_session_path @sign_in_params
      expect(response).to be_success 
    end
  end

  describe 'Testing headers after login' do
  	before do
      post user_registration_path @registration_params
      user = User.last
  	  auth_headers = user.create_new_auth_token
  	  post user_session_path, params: @sign_in_params, headers: auth_headers
  	end

    # it 'should have in response header "access-token"' do
    #   post user_registration_path @registration_params
    #   expect(response.has_header?('access-token')).to eq(true)
    # end
  end

end
