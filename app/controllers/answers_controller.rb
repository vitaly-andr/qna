class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [ :edit, :update, :destroy ]

  def new
    @answer = @question.answers.build
    @answer.author = current_user

  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user


    if @answer.save
      redirect_to @question, notice: "Answer was successfully created."
    else
      @answers = @question.answers
      render "questions/show"
    end
  end

  def edit
    redirect_to @question, alert: 'You can edit only your own answers.' unless current_user.author_of?(@answer)
  end

  def update
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        redirect_to @question, notice: 'Your answer was successfully updated.'
      else
        render :edit
      end
    else
      redirect_to @question, alert: 'You can update only your own answers.'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer was successfully deleted.'
    else
      redirect_to @question, alert: 'You can delete only your own answers.'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
