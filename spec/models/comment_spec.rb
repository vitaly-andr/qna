require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe 'associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:author) }
  end

  describe 'polymorphic association with commentable' do
    it 'can be associated with a question' do
      comment = build(:comment, commentable: question, author: user)
      expect(comment.commentable).to eq(question)
      expect(comment).to be_valid
    end

    it 'can be associated with an answer' do
      comment = build(:comment, commentable: answer, author: user)
      expect(comment.commentable).to eq(answer)
      expect(comment).to be_valid
    end
  end
end
