require 'rails_helper'

feature 'User can see link previews', %q(
  In order to quickly preview link content
  As an authenticated or unauthenticated user
  I want to be able to see previews for Gist links and other links
), js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees Gist link preview' do
      fill_in 'Your Answer', with: 'This is my answer with a Gist link'

      click_on 'Add Link'
      within all('.nested-fields').first do
        fill_in 'Link name', with: 'Gist link'
        fill_in 'Url', with: 'https://gist.github.com/vitaly-andr/83bdcd7a1a1282cb17085714494ded2a'
      end

      click_on 'Submit Answer'

      within "#answers" do
        expect(page).to have_content 'This is my answer with a Gist link'
        expect(page).to have_content 'Gist of vitaly-andr'
        expect(page).to have_content 'Gist content here...'
      end
    end

    scenario 'sees preview for a non-Gist link using Microlink.js' do
      fill_in 'Your Answer', with: 'This is my answer with a regular link'

      click_on 'Add Link'
      within all('.nested-fields').first do
        fill_in 'Link name', with: 'GitHub'
        fill_in 'Url', with: 'https://github.com'
      end

      click_on 'Submit Answer'

      within "#answers" do
        expect(page).to have_content 'This is my answer with a regular link'
        expect(page).to have_selector '.microlink_card' # Это будет селектор Microlink.js
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'sees previews for both Gist and regular links in existing answers' do
      answer = create(:answer, question: question)
      create(:link, name: 'Gist link', url: 'https://gist.github.com/vitaly-andr/83bdcd7a1a1282cb17085714494ded2a', linkable: answer)
      create(:link, name: 'GitHub', url: 'https://github.com', linkable: answer)

      visit question_path(question)

      within "#answers" do
        expect(page).to have_content 'Gist link'
        expect(page).to have_content 'Gist of vitaly-andr'
        expect(page).to have_content 'Gist content here...'

        expect(page).to have_content 'GitHub'
        expect(page).to have_selector '.microlink_card'
      end
    end
  end
end
