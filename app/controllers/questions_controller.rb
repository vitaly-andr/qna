class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_question, only: [ :show, :edit, :update, :destroy, :mark_best_answer, :unmark_best_answer ]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = @question.best_answer
    @answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
    @question.links.build
  end

  def edit

  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      respond_to do |format|
        format.html { redirect_to @question, notice: "Question was successfully created." }
        # format.turbo_stream { render_flash_notice("Question was successfully created.") }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = @question.errors.full_messages.join(", ")
          render :new
        end
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('question_form', partial: 'questions/form', locals: { question: @question }),
            render_flash_alert(@question.errors.full_messages.join(", "))
          ]
        end
      end
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

  def mark_best_answer
    @answer = @question.answers.find(params[:answer_id])
    @previous_best_answer = @question.best_answer

    if current_user.author_of?(@question)
      if @question.update(best_answer: @answer)

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @question, notice: 'Best answer selected.' }
        end

      else
        respond_to do |format|
          format.html { redirect_to @question, alert: 'Failed to select the best answer.' }
        end
      end
    else
      redirect_to @question, alert: 'You are not authorized to select the best answer.'
    end
  end

  def unmark_best_answer
    if current_user == @question.author
      @question.update(best_answer: nil)
      redirect_to @question, notice: 'Best answer unmarked.'
    else
      redirect_to @question, alert: 'You are not authorized to unmark the best answer.'
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer_id, files: [], links_attributes: [:name, :url])
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
        render turbo_stream: [
          turbo_stream.replace(helpers.dom_id(@question), partial: 'questions/question', locals: { question: @question }),
          render_flash_notice('Question successfully updated.')
        ]
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

end

