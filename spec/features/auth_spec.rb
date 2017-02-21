require 'spec_helper'
require 'rails_helper'

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

feature "the signup process" do

  scenario "has a new user page" do
    visit new_user_url
    expect(page).to have_content "Sign Up"
  end

  feature "signing up a user" do
    before(:each) do
      sign_up_as("HanSolo")
    end

    scenario "shows username on the homepage after signup" do
      expect(page).to have_content "HanSolo"
    end
  end

end

feature "logging in" do
  let(:han) { User.create(username: "HanSolo", password: "password")}

  scenario "shows username on the homepage after login" do
    sign_up_as("HanSolo")
    click_on "Log Out"
    log_in_as(han)
    expect(page).to have_content "HanSolo"
  end
end

feature "logging out" do
  let(:luke) { User.new(username: "LukeSkywalker")}

  scenario "begins with a logged out state" do
    visit users_url
    expect(page).to have_content("Sign In")
  end

  scenario "doesn't show username on the homepage after logout" do
    sign_up_as(luke)
    click_on "Log Out"
    expect(page).not_to have_content(luke.username)
  end

end
