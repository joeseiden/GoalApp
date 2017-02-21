module AuthFeaturesHelper
  def sign_up_as(username)
    visit new_user_url
    fill_in 'username', with: username
    fill_in 'password', with: 'password'
    click_on "Create User"
  end

  def log_in_as(user)
    visit new_session_url
    fill_in 'username', with: user.username
    fill_in 'password', with: user.password
    click_on 'Log In'
  end
end
