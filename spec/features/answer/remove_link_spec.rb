require 'rails_helper'

feature 'Author can delete links from their answer', "
  In order to remove irrelevant links
  As an author of the answer
  I'd like to be able to delete links from my answer
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user', js: true do    scenario 'Author deletes link from their answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link link.name, href: link.url

    within "#answer_#{answer.id}" do

      within "#link_#{link.id}" do
        click_on 'X'
      end

    end

    expect(page).to_not have_link link.name, href: link.url
  end


  scenario 'Another user tries to delete link from someone else\'s answer' do
      sign_in(other_user)
      visit question_path(question)

      within "#answer_#{answer.id}" do
        expect(page).to have_link link.name, href: link.url
        expect(page).to_not have_link 'X'
      end
    end
  end

  scenario 'Unauthenticated user cannot delete links from answer' do
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to have_link link.name, href: link.url
      expect(page).to_not have_link 'X'
    end
  end
end
