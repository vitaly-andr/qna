require 'rails_helper'

feature 'Author can delete their question', %q(
  In order to remove unnecessary question
  As an authenticated user
  I want to be able to delete my question
), js: true do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:other_question) { create(:question, author: other_user) }

  scenario 'Author tries to delete their question from the question page' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link 'Delete Question'
    click_on 'Delete Question'

    expect(page).to have_content 'Your question was successfully deleted.'
    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title_was
  end

  scenario 'Non-author tries to delete someone else’s question' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete Question'
  end

  scenario 'Author tries to delete their question from the index page' do
    sign_in(user)
    visit questions_path

    within "#question_#{question.id}" do
      expect(page).to have_link 'Delete Question'
      click_on 'Delete Question'
    end

    expect(page).to have_content 'Your question was successfully deleted.'
    expect(page).to_not have_content question.title_was
  end

  scenario 'Non-author tries to delete someone else’s question from the index page' do
    sign_in(other_user)
    visit questions_path
    within "#question_#{question.id}" do
      expect(page).to_not have_link 'Delete Question'
    end
  end
end
