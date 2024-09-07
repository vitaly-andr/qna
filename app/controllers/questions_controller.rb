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
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end
  def destroy
    respond_to do |format|
      if current_user.author_of?(@question)
        @question.destroy
        # flash.now[:notice] = "Your question was successfully deleted."

        format.html { redirect_to questions_path, notice: "Your question was successfully deleted." }

        format.turbo_stream do
          if turbo_frame_request?
            render turbo_stream: [
              turbo_stream.remove(@question),
              turbo_stream.replace("flash-messages", partial: "shared/flash", locals: { flash: { notice: "Your question was successfully deleted." } })
            ]
          else
            redirect_to questions_path, notice: "Your question was successfully deleted."
          end
        end

      else
        format.html { redirect_to questions_path, alert: "You can delete only your own questions." }

        format.turbo_stream do
          turbo_stream.replace("flash-messages", partial: "shared/flash", locals: { flash: { alert: "You can delete only your own questions." } })
        end
      end
    end
  end


  private
  def set_question
    @question = Question.find(params[:id])
  end
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
