require 'rails_helper'

feature 'Author can delete links from their question', "
  In order to remove irrelevant links
  As an author of the question
  I'd like to be able to delete links from my question
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user', js: true do
    scenario 'Author deletes link from their question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_link link.name, href: link.url

      click_on 'Remove'

      expect(page).to_not have_link link.name, href: link.url
      expect(page).to have_content 'Link was successfully removed.'
    end

    scenario 'Another user tries to delete link from someone else\'s question' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to have_link link.name, href: link.url
      expect(page).to_not have_link 'Remove'
    end
  end

  scenario 'Unauthenticated user cannot delete links' do
    visit question_path(question)

    expect(page).to have_link link.name, href: link.url
    expect(page).to_not have_link 'Remove'
  end
end
