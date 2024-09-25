require 'rails_helper'

feature 'Voting for an answer', %q{
  In order to vote for an answer I like
  As an authenticated user
  I'd like to be able to vote for or against an answer on the question page
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user votes for an answer', js: true do
    within "##{dom_id(answer)} .vote-area" do
      click_on 'Upvote'

      expect(find('.vote__rating').text).to eq '1'
    end
  end

  scenario 'Authenticated user votes against an answer', js: true do
    within "##{dom_id(answer)} .vote-area" do
      click_on 'Downvote'

      expect(find('.vote__rating').text).to eq '-1'
    end
  end

  scenario 'Authenticated user cannot vote for their own answer', js: true do
    click_on 'Sign out'
    sign_in(author)
    visit question_path(question)

    within "##{dom_id(answer)} .vote-area" do
      expect(page).not_to have_link 'Upvote'
      expect(page).not_to have_link 'Downvote'
    end
  end

  scenario 'Authenticated user can cancel their vote and vote again for an answer', js: true do
    within "##{dom_id(answer)} .vote-area" do
      click_on 'Upvote'
      expect(find('.vote__rating').text).to eq '1'

      click_on 'Cancel vote'
      expect(find('.vote__rating').text).to eq '0'

      click_on 'Downvote'
      expect(find('.vote__rating').text).to eq '-1'
    end
  end

  scenario 'Authenticated user can vote only once per answer', js: true do
    within "##{dom_id(answer)} .vote-area" do
      click_on 'Upvote'
      expect(find('.vote__rating').text).to eq '1'

      click_on 'Upvote'
      expect(page).to have_content 'You have already voted'
    end
  end
end
