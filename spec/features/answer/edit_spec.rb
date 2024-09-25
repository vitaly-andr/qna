require 'rails_helper'

feature 'Author can edit their answer', %q(
  In order to fix mistakes
  As an authenticated user
  I want to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Author edits their answer and attaches files', js: true do
    sign_in(user)
    visit question_path(question)

    within "turbo-frame##{dom_id(answer)}" do
      click_on 'Edit'

      fill_in 'Your Answer', with: 'Edited answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Update Answer'

      expect(page).to_not have_selector 'textarea'
      expect(page).to have_content 'Edited answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end


  scenario 'Non-author cannot see the Edit link for someone else’s answer' do
    sign_in(other_user)
    visit question_path(question)

    within "turbo-frame##{dom_id(answer)}" do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user cannot see the Edit link' do
    visit question_path(question)

    within "turbo-frame##{dom_id(answer)}" do
      expect(page).to_not have_link 'Edit'
    end
  end
end