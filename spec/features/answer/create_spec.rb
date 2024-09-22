require 'rails_helper'

feature 'User can write an answer to a question', %q(
  In order to help other users
  As an authenticated user
  I want to be able to write an answer to a question directly on its page
), js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:existing_answer) { create(:answer, question: question, body: 'Existing answer') }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'with full page reload' do
      scenario 'writes an answer' do
        within "#answers" do
          expect(page).to have_content 'Existing answer'
        end

        fill_in 'Your Answer', with: 'This is my new answer'
        click_on 'Submit Answer'

        within "#answers" do
          expect(page).to have_content 'This is my new answer'
        end
      end

      scenario 'tries to submit an empty answer' do
        click_on 'Submit Answer'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'writes an answer with attached files' do
      fill_in 'Your Answer', with: 'This is my answer with files'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Submit Answer'

      within "#answers" do
        expect(page).to have_content 'This is my answer with files'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    context 'with Turbo Frame' do
      scenario 'writes an answer' do
        within "#answers" do
          expect(page).to have_content 'Existing answer'
        end

        fill_in 'Your Answer', with: 'This is my new answer'
        click_on 'Submit Answer'

        within "#answers" do
          expect(page).to have_content 'This is my new answer'
        end
        # expect(page).to have_selector 'textarea'
        expect(find_field('Your Answer').value).to be_empty
      end

      scenario 'writes an answer with attached files' do
        fill_in 'Your Answer', with: 'This is my answer with files'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Submit Answer'

        within "#answers" do
          expect(page).to have_content 'This is my answer with files'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
        expect(find_field('Your Answer').value).to be_empty
      end

      scenario 'tries to submit an empty answer' do
        click_on 'Submit Answer'
        within '.answer-errors' do
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)

    expect(page).to_not have_selector 'textarea'
    expect(page).to have_content 'You need to sign in or sign up before creating answers.'
  end
end
