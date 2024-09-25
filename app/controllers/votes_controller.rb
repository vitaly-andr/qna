class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable
  before_action :ensure_not_own_votable, only: [:create]

  def create
    if @votable.voted_by?(current_user)
      render json: { error: 'You have already voted' }, status: :unprocessable_entity
    else
      @votable.vote_by(current_user, params[:value].to_i)
      render json: { rating: @votable.rating }
    end
  end

  def destroy
    if @votable.voted_by?(current_user)
      @votable.cancel_vote_by(current_user)
      render json: { rating: @votable.rating }
    else
      render json: { error: 'You have not voted yet' }, status: :unprocessable_entity
    end
  end

  private

  def find_votable
    @votable = params[:votable_type].classify.constantize.find(params[:votable_id])
  end

  def ensure_not_own_votable
    if @votable.author == current_user
      render json: { error: 'You cannot vote for your own content' }, status: :forbidden
    end
  end
end
