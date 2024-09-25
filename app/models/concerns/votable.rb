module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def vote_by(user, value)
    vote = votes.find_or_initialize_by(user: user)
    vote.update(value: value)
  end

  def cancel_vote_by(user)
    votes.find_by(user: user)&.destroy
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end

  def voted_value_by(user)
    votes.find_by(user: user)&.value
  end
end
