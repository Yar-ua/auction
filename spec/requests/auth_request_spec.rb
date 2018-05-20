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
      first_name: first_name,
      last_name: last_name,
      birth_day: birth_day
    }
  end

  describe 'Testing access to resourses' do
    it 'Resource forbidden, if user not authenticated' do
      get about_path
      expect(response.status).to eq(401)
    end
  end

  describe 'Testing registration: POST /auth' do
    it 'should respond with 200 OK' do
      registration
      expect(response).to be_success 
    end

    it 'should increase user count by 1' do
      expect{
        registration
      }.to change(User, :count).by(1)
    end
  end

  describe 'Testing confirm registration: GET /auth/confirmation' do
    before do
      registration
    end

    it 'should respond with 301 REDIRECTION' do
      register_confirmation
      expect(response).to be_redirect
    end
  end

  describe 'Testing login: POST /auth/sign_in' do
    before do
      registration
      register_confirmation
      sign_in
      @auth_params = get_auth_params_from_login_response_headers(response)
    end

    it 'should respond with 200 OK' do
      expect(response).to be_success 
    end

    it 'After sign_in it should have in response header "access-token", "uid", "client"' do
      expect(response.has_header?('access-token')).to eq(true)
      expect(response.has_header?('uid')).to eq(true)
      expect(response.has_header?('client')).to eq(true)
    end

    it 'Loginned user has rights to all resources' do
      get about_path, headers: @auth_params
      expect(response.status).to eq(200)
    end

    it 'Resources forbidden for incorrect token' do
      @auth_params['access-token'] = 123123
      get about_path, headers: @auth_params
      expect(response.status).to eq(401)
    end

    describe 'Testing sign_out: DELETE /auth/sign_out' do
      it 'sign_out must be succsessful' do
        delete destroy_user_session_path, headers: @auth_params
        expect(response.status).to eq(200)
        expect(response.body).to eq('{"success":true}')
      end
    end
  end

  describe 'Testing reset password' do
    before do
      registration
      register_confirmation
      sign_in
      @auth_params = get_auth_params_from_login_response_headers(response)
      post user_password_path(email: @registration_params[:email], 
          redirect_url: 'auth/password/edit', headers: @auth_params)
      @auth_params = get_auth_params_from_login_response_headers(response)
    end

    it 'password reset response should be 200 ok' do
      expect(response.status).to eq(200)
    end

    describe 'confirmation reset passord' do
      it 'should be successfully' do
        # reset password confirmation
        user = User.last
        get edit_user_password_path(:config => 'default', :reset_password_token => user.reset_password_token, 
            redirect_url: 'auth/password/edit')
        expect(response.status).to eq(302)
        #get 'http://localhost/auth/password/edit?config=default&redirect_url=auth%2Fpassword%2Fedit&reset_password_token="#{user.reset_password_token}"'
      end
    end
  end


  # helper to get headers params
  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token_type' => token_type
    }
    auth_params
  end

  def sign_in
    post user_session_path @sign_in_params
  end

  def registration
    post user_registration_path @registration_params
  end

  def register_confirmation
    user = User.last
    get user_confirmation_path(:config => 'default', 
      :confirmation_token => user.confirmation_token, :redirect_url => '/')
  end

end
