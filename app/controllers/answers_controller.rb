class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.build
    @answer.author = current_user
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    respond_to do |format|
      if @answer.save
        @new_answer = @question.answers.build
        format.html { redirect_to @question, notice: "Answer was successfully created." }
        format.turbo_stream { render 'answers/create' }
      else
        format.html do
          @answers = @question.answers
          render "questions/show"
        end
        format.turbo_stream { render 'answers/create_error' }
      end
    end
  end

  def edit
    @question = @answer.question
    redirect_to @question, alert: "You can edit only your own answers." unless current_user.author_of?(@answer)
  end

  def update
    @question = @answer.question
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        redirect_to @question, notice: "Your answer was successfully updated."
      else
        render :edit
      end
    else
      redirect_to @question, alert: "You can update only your own answers."
    end
  end

  def destroy
    @question = @answer.question
    respond_to do |format|
      if current_user.author_of?(@answer)
        @answer.destroy
        format.html { redirect_to @question, notice: "Your answer was successfully deleted." }
        format.turbo_stream do
          if turbo_frame_request?
            render turbo_stream: [
              turbo_stream.remove(@answer),
              turbo_stream.replace("flash-messages", partial: "shared/flash", locals: { flash: { notice: "Your answer was successfully deleted." } })
            ]
          end
        end
      else
        format.html { redirect_to @question, alert: "You can delete only your own answers." }
        format.turbo_stream do
          turbo_stream.replace("flash-messages", partial: "shared/flash", locals: { flash: { alert: "You can delete only your own answers." } })
        end
      end
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
