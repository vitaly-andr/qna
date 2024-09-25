require 'rails_helper'

feature 'Voting for a question', %q{
  In order to vote for a question I like
  As an authenticated user
  I'd like to be able to vote for or against a question on the question page
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user votes for a question', js: true do
    within ".section#question-links" do
      click_on 'Upvote'

      expect(page).to have_content 'Rating: 1'
    end
  end

  scenario 'Authenticated user votes against a question', js: true do
    within ".section#question-links" do
      click_on 'Downvote'

      expect(page).to have_content 'Rating: -1'
    end
  end

  scenario 'Authenticated user cannot vote for their own question', js: true do
    sign_out(user)
    sign_in(author)
    visit question_path(question)

    within ".section#question-links" do
      expect(page).not_to have_link 'Upvote'
      expect(page).not_to have_link 'Downvote'
    end
  end

  scenario 'Authenticated user can cancel their vote and vote again', js: true do
    within ".section#question-links" do
      click_on 'Upvote'
      expect(page).to have_content 'Rating: 1'

      click_on 'Cancel vote'
      expect(page).to have_content 'Rating: 0'

      click_on 'Downvote'
      expect(page).to have_content 'Rating: -1'
    end
  end

  scenario 'Authenticated user can vote only once per question', js: true do
    within ".section#question-links" do
      click_on 'Upvote'
      expect(page).to have_content 'Rating: 1'

      click_on 'Upvote'
      expect(page).to have_content 'You have already voted'
    end
  end
end

feature 'Voting for a question on index page', %q{
  In order to vote for a question I like
  As an authenticated user
  I'd like to be able to vote for or against a question on the index page
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  background do
    sign_in(user)
    visit questions_path
  end

  scenario 'Authenticated user votes for a question on index', js: true do
    within turbo_frame_tag(dom_id(question)) do
      click_on 'Upvote'

      expect(page).to have_content 'Rating: 1'
    end
  end

  scenario 'Authenticated user votes against a question on index', js: true do
    within turbo_frame_tag(dom_id(question)) do
      click_on 'Downvote'

      expect(page).to have_content 'Rating: -1'
    end
  end

  scenario 'Authenticated user cannot vote for their own question on index', js: true do
    sign_out(user)
    sign_in(author)
    visit questions_path

    within turbo_frame_tag(dom_id(question)) do
      expect(page).not_to have_link 'Upvote'
      expect(page).not_to have_link 'Downvote'
    end
  end

  scenario 'Authenticated user can cancel their vote and vote again on index', js: true do
    within turbo_frame_tag(dom_id(question)) do
      click_on 'Upvote'
      expect(page).to have_content 'Rating: 1'

      click_on 'Cancel vote'
      expect(page).to have_content 'Rating: 0'

      click_on 'Downvote'
      expect(page).to have_content 'Rating: -1'
    end
  end

  scenario 'Authenticated user can vote only once per question on index', js: true do
    within turbo_frame_tag(dom_id(question)) do
      click_on 'Upvote'
      expect(page).to have_content 'Rating: 1'

      click_on 'Upvote'
      expect(page).to have_content 'You have already voted'
    end
  end
end