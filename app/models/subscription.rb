class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscribable, polymorphic: true

  validates :user, presence: true
  validates :subscribable, presence: true
end
