class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :update, :destroy, :delete_attachment]

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
    unless current_user.author_of?(@answer)
      flash[:alert] = 'You can edit only your own answers.'
      redirect_to @answer.question
    end
  end

  def update
    @question = @answer.question
    unless current_user.author_of?(@answer)
      return handle_unauthorized_update
    end

    if @answer.update(answer_params)
      respond_to do |format|
        format.html { redirect_to @answer.question, notice: 'Your answer was successfully updated.' }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(helpers.dom_id(@answer), partial: 'answers/answer', locals: { answer: @answer }),
            render_flash_notice('Your answer was successfully updated.')
          ]
        end
      end
    else
      handle_failed_update
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

  def delete_attachment
    file = @answer.files.find(params[:file_id])

    if current_user.author_of?(@answer)
      file.purge
      respond_to do |format|
        format.html { redirect_to question_path(@answer.question), notice: 'File was successfully deleted.' }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("file_#{file.id}"),  # Удаление HTML-элемента файла
            turbo_stream.replace("flash", partial: "shared/flash", locals: { notice: 'File was successfully deleted.' })
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to question_path(@answer.question), alert: 'You are not authorized to delete this file.' }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "shared/flash", locals: { alert: 'You are not authorized to delete this file.' })
          ]
        end
      end
    end
  end

  private

  def handle_unauthorized_update
    respond_to do |format|
      format.html { redirect_to @question, alert: 'You can update only your own answers.' }
      format.turbo_stream { render_flash_alert('You can update only your own answers.') }
    end
  end

  def handle_failed_update
    respond_to do |format|
      format.html { render :edit }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@answer), partial: 'answers/form', locals: { answer: @answer })
      end
    end
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :file_id, files: [])
  end
end
