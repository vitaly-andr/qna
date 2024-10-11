class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    users = User.all
    questions = Question.where('created_at >= ?', 1.day.ago).map do |question|
      {
        title: question.title,
        url: Rails.application.routes.url_helpers.question_url(question, host: 'localhost', port: 3000)
      }
    end

    users.each do |user|
      DailyDigestMailer.digest(user, questions).deliver_now
    end
  end
end
