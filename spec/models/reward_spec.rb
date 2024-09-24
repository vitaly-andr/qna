require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user).optional }
    it { should have_one_attached(:image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:image) }
  end

  describe 'reward creation' do
    let(:question) { create(:question) }
    let(:reward) { build(:reward, question: question) }

    it 'is valid with valid attributes' do
      expect(reward).to be_valid
    end

    it 'is not valid without a title' do
      reward.title = nil
      expect(reward).to_not be_valid
    end

    it 'is not valid without an image' do
      reward.image = nil
      expect(reward).to_not be_valid
    end

    it 'is not assigned to a user initially' do
      expect(reward.user).to be_nil
    end

    it 'can be assigned to a user after best answer is chosen' do
      user = create(:user)
      reward.user = user
      reward.save
      expect(reward.user).to eq(user)
    end
  end
end
