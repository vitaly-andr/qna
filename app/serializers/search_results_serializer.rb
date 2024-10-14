class SearchResultsSerializer < ActiveModel::Serializer
  def initialize(results)
    @results = results
  end

  def as_json(*)
    @results.map do |result|
      case result
        when Question
          {
            type: 'question',
            title: result.title.truncate(100),
            url: Rails.application.routes.url_helpers.question_path(result)
          }
        when Answer
          {
            type: 'answer',
            body: result.body.truncate(100),
            url: "#{Rails.application.routes.url_helpers.question_path(result.question)}#answer_#{result.id}"
          }
        when Comment
          {
            type: 'comment',
            body: result.body.truncate(100),
            url: "#{Rails.application.routes.url_helpers.polymorphic_path(result.commentable)}#comment_#{result.id}"
          }
        when User
          {
            type: 'user',
            name: result.name,
            url: Rails.application.routes.url_helpers.user_path(result)
          }
        else
          {}
      end
    end
  end
end
