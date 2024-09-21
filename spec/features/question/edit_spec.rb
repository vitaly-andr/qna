require 'rails_helper'

feature 'Author can edit their question', %q(
  In order to correct mistakes or add details
  As an authenticated user and author of the question
  I want to be able to edit my question inline
), js: true do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Author edits their question from the index page and attaches files' do
    sign_in(user)
    visit questions_path

    within "#question_#{question.id}" do
      click_on 'Edit Question'

      fill_in 'Title', with: 'Edited Question Title'
      fill_in 'Body', with: 'Edited Question Body'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Save'

      expect(page).to have_no_selector 'textarea'
      expect(page).to have_content 'Edited Question Title'
      expect(page).to have_content 'Edited Question Body'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Non-author tries to edit someone else’s question' do
    sign_in(other_user)
    visit questions_path

    within "#question_#{question.id}" do
      expect(page).to_not have_link 'Edit Question'
    end
  end

  scenario 'Author edits their question from the question show page and attaches files' do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit Question'

    fill_in 'Title', with: 'Edited Question Title on Show'
    fill_in 'Body', with: 'Edited Question Body on Show'

    attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

    click_on 'Save'

    expect(page).to_not have_selector 'textarea'
    expect(page).to have_content 'Edited Question Title on Show'
    expect(page).to have_content 'Edited Question Body on Show'

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
end
