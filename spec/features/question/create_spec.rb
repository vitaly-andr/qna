require 'rails_helper'

feature 'User can create question', %q(
In order to create question
As authenticated user
I want to be able to create questions
) do
  given(:user) { create(:user) }
  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end
    scenario 'creates question' do
      fill_in 'Title', with: 'Title text'
      fill_in 'Body', with: 'text text text'
      click_on 'Create Question'
      expect(page).to have_content('Question was successfully created.')
      expect(page).to have_content('Title text')
      expect(page).to have_content('text text text')
    end
    scenario 'tries to create question with errors' do
      click_on 'Create Question'
      # save_and_open_page
      expect(page).to have_content("Title can't be blank")
    end
  end

  scenario 'Non-authenticated user tries to create question' do
    visit new_question_path
    expect(page).to have_content("You need to sign in or sign up before continuing.")
    # save_and_open_page
    # click_on 'Create Question'
  end

end