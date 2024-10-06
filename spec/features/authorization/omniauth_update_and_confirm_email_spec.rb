require 'rails_helper'
require 'capybara/email/rspec'

RSpec.feature "OmniAuthUpdateAndConfirmEmail", type: :feature do
  before do
    # Mock OmniAuth for VKontakte login
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
                                                                     provider: 'vkontakte',
                                                                     uid: '123545',
                                                                     info: { name: 'Test User', email: nil } # No email provided, triggers temp email creation
                                                                   })
  end

  scenario 'User signs in via VKontakte, updates email and password, confirms email, and logs in' do
    # Step 1: User clicks the VKontakte sign-in button
    visit new_user_session_path
    click_button 'Sign in with Vkontakte' # Assuming this is the button for VKontakte sign-in

    # Step 2: Expect to be redirected to the edit profile page
    expect(page).to have_current_path(edit_user_registration_path)
    expect(page).to have_content('Please update and confirm your email and create new password')

    # Step 3: Fill in the form with new email and new password
    new_email = 'new-email@example.com'
    new_password = 'newpassword123'
    fill_in 'Email', with: new_email
    fill_in 'Password', with: new_password
    fill_in 'Password confirmation', with: new_password
    click_button 'Update'

    # Step 4: Open the confirmation email
    open_email(new_email)
    expect(current_email).to have_content ' You can confirm your account email through the link below'

    # Step 5: Click the confirmation link
    current_email.click_link 'Confirm my account'

    # Step 6: Log out to log in again
    click_link 'Sign out'

    # Step 7: Log in with the new email and new password
    visit new_user_session_path
    fill_in 'Email', with: new_email
    fill_in 'Password', with: new_password
    click_button 'Log in'

    # Step 8: Expect to see the "Signed in successfully" message
    expect(page).to have_content('Signed in successfully')
  end
end
