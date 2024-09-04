require 'rails_helper'
feature 'User can sign in', %q{
In order to sign in
As a unautheticated user
I want to sign in
} do
  given(:user) { create(:user) }
  background { visit new_user_session_path }
  scenario 'Registered user attempts to sign in' do
    # User.create!(email: 'user@example.com', password: 'password')
    # fill_in 'Email', with: 'user@example.com'
    # fill_in 'Password', with: 'password'
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
  end
  scenario 'Unregistered user attempts to sign in' do
    fill_in 'Email', with: 'wrong@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    # save_and_open_page
    expect(page).to have_content 'Invalid Email or password.'
  end
end