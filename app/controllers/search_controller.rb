class SearchController < ApplicationController
  def index
    @query = params[:query]
    @model = params[:model]

    if @query.present?
      case @model
        when "questions"
          @results = Question.search(@query)
        when "answers"
          @results = Answer.search(@query)
        when "comments"
          @results = Comment.search(@query)
        when "users"
          @results = User.search(@query)
        else
          @results = (
            Question.search(@query).to_a +
              Answer.search(@query).to_a +
              Comment.search(@query).to_a +
              User.search(@query).to_a
          )
      end
    end

    respond_to do |format|
      format.html # Для обычных HTML запросов
      format.json { render json: SearchResultsSerializer.new(@results).as_json }
    end
  end
end
