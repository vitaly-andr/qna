class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_question, only: [ :show, :edit, :update, :destroy ]
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end
  def new
    @question = Question.new
  end
  def edit
  end
  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: "Question was successfully created."
    else
      render :new
    end
  end
  def update
    return handle_unauthorized_update unless current_user.author_of?(@question)

    @question.update(question_params) ? handle_successful_update : handle_failed_update
  end
  def destroy
    return handle_unauthorized_destroy unless current_user.author_of?(@question)

    @question.destroy
    handle_successful_destroy
  end


  private
  def set_question
    @question = Question.find(params[:id])
  end
  def question_params
    params.require(:question).permit(:title, :body)
  end
  def handle_unauthorized_update
    respond_to do |format|
      format.html { redirect_to @question, alert: 'Only the author can edit this question.' }
      format.turbo_stream { render_flash_alert('Only the author can edit this question.') }
    end
  end

  def handle_unauthorized_destroy
    respond_to do |format|
      format.html { redirect_to questions_path, alert: 'You can delete only your own questions.' }
      format.turbo_stream { render_flash_alert('You can delete only your own questions.') }
    end
  end

  def handle_successful_update
    respond_to do |format|
      format.html { redirect_to @question, notice: 'Question successfully updated.' }
      format.turbo_stream do
        render turbo_stream: render_flash_notice('Question successfully updated.')
      end
    end
  end

  def handle_failed_update
    respond_to do |format|
      format.html { render :edit }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('question_form', partial: 'questions/form', locals: { question: @question })
      end
    end
  end

  def handle_successful_destroy
    respond_to do |format|
      if turbo_frame_request?
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@question),
            render_flash_notice('Your question was successfully deleted.')
          ]
        end
      else
        format.html { redirect_to questions_path, notice: "Your question was successfully deleted." }
      end
    end
  end

  # Reusable flash rendering
  def render_flash_notice(message)
    turbo_stream.replace('flash-messages', partial: 'shared/flash', locals: { flash: { notice: message } })
  end

  def render_flash_alert(message)
    turbo_stream.replace('flash-messages', partial: 'shared/flash', locals: { flash: { alert: message } })
  end
end

