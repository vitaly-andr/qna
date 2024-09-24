class RewardsController < ApplicationController
  def index
    @rewards = current_user.rewards.includes(:question)
  end
end