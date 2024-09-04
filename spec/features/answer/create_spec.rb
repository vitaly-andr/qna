require 'rails_helper'

feature 'User can write an answer to a question', %q(
  In order to help other users
  As an authenticated user
  I want to be able to write an answer to a question directly on its page
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'writes an answer' do
      fill_in 'Your Answer', with: 'This is my answer'
      click_on 'Submit Answer'

      expect(page).to have_content 'Your answer was successfully submitted.'
      expect(page).to have_content 'This is my answer'
    end

    scenario 'tries to submit an empty answer' do
      click_on 'Submit Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)

    expect(page).to_not have_selector 'textarea'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end