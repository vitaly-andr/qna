require 'rails_helper'

feature 'User can register', %q{
  In order to ask questions and provide answers
  As an unauthenticated user
  I want to be able to register from the login page
} do

  background do
    visit new_user_session_path
    click_on 'Sign up'
  end

  scenario 'User registers with valid data' do
    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_content 'Sign out'
  end

  scenario 'User registers with invalid data' do
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''

    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
