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
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: "Your question was successfully deleted."
    else
      redirect_to questions_path, alert: "You can delete only your own questions."
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
