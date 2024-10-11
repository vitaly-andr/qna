class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscribable
  before_action :authorize_subscription, only: [:destroy]

  def create
    @subscription = @subscribable.subscriptions.new(user: current_user)
    authorize @subscription
    @subscription.save
    respond_to do |format|
      format.turbo_stream
      format.html { head :ok }
    end
  end

  def destroy
    @subscription = @subscribable.subscriptions.find_by(user: current_user)
    @subscription&.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { head :ok }
    end
  end

  private
  def set_subscribable
    @subscribable = find_subscribable
  end
  def find_subscribable
    if params[:question_id]
      Question.find(params[:question_id])
    elsif params[:answer_id]
      Answer.find(params[:answer_id])
    else
      raise ActiveRecord::RecordNotFound, "Could not find subscribable object"
    end
  end

  def authorize_subscription
    @subscription = @subscribable.subscriptions.find_by(user: current_user)
    authorize @subscription
  end
end