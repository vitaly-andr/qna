require 'rails_helper'

feature 'User can see link previews in a question', %q(
  In order to quickly preview link content
  As an authenticated or unauthenticated user
  I want to be able to see previews for Gist links and other links in the question
), js: true do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'creates question with a Gist link and sees Gist content on the page' do
      fill_in 'Title', with: 'Test question with Gist link'
      fill_in 'Body', with: 'This is a question with a Gist link'

      within '.nested-fields' do
        fill_in 'Link name', with: 'Gist link'
        fill_in 'Url', with: 'https://gist.github.com/vitaly-andr/83bdcd7a1a1282cb17085714494ded2a'
      end

      click_on 'Save'

      expect(page).to have_content('Question was successfully created.')

      within '.gist-preview' do
        expect(page).to have_content 'content of the Gist file'
      end
    end

    scenario 'creates question with a regular link and sees the link on the page' do
      fill_in 'Title', with: 'Test question with regular link'
      fill_in 'Body', with: 'This is a question with a regular link'

      within '.nested-fields' do
        fill_in 'Link name', with: 'GitHub'
        fill_in 'Url', with: 'https://github.com'
      end

      click_on 'Save'

      expect(page).to have_content('Question was successfully created.')

      within '#question-links' do
        expect(page).to have_link 'GitHub', href: 'https://github.com'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'sees Gist content and regular link in an existing question' do
      question_with_links = create(:question, author: user)
      create(:link, name: 'Gist link', url: 'https://gist.github.com/vitaly-andr/83bdcd7a1a1282cb17085714494ded2a', linkable: question_with_links)
      create(:link, name: 'GitHub', url: 'https://github.com', linkable: question_with_links)

      visit question_path(question_with_links)

      within '.gist-preview' do
        expect(page).to have_content 'content of the Gist file'
      end

      # Проверка обычной ссылки
      within '#question-links' do
        expect(page).to have_link 'GitHub', href: 'https://github.com'
      end
    end
  end
end
