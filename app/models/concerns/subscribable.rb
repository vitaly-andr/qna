module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, as: :subscribable, dependent: :destroy
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end
end