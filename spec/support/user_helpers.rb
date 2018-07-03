def login_user
  @user = FactoryBot.create(:user)
  request.headers.merge! @user.create_new_auth_token
end