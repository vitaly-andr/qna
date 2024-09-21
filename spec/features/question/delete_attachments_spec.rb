require 'rails_helper'

feature 'Author can delete attached files from their question', %q(
  In order to remove unnecessary files
  As an authenticated user and author of the question
  I want to be able to delete attached files
), js: true do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  background do
    question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
  end

  scenario 'Author deletes one of the attached files', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      # Проверяем, что файлы прикреплены
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      # Удаляем один файл
      within "#file_#{question.files.first.id}" do
        click_on 'Delete File'
      end

      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Non-author cannot see delete links for files', js: true do
    sign_in(other_user)
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'Delete File'
    end
  end

  scenario 'Unauthenticated user cannot see delete links for files', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'Delete File'
    end
  end
end
