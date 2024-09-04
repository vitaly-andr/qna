require 'rails_helper'

feature 'Author can delete their question', %q{
  In order to remove unnecessary question
  As an authenticated user
  I want to be able to delete my question
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:other_question) { create(:question, author: other_user) }

  scenario 'Author tries to delete their question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link 'Delete Question'
    click_on 'Delete Question'

    expect(page).to have_content 'Your question was successfully deleted.'
    expect(page).to_not have_content question.title
  end

  scenario 'Non-author tries to delete someone else’s question' do
    sign_in(user)
    visit question_path(other_question)

    expect(page).to_not have_link 'Delete Question'
  end
end
