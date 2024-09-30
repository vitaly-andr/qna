class LiveFeedController < ApplicationController
  def index
    @questions = Question.includes(:answers).order(created_at: :desc)
  end
end