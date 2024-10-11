class NotificationService
  def self.call(answer)
    new(answer).call
  end

  def initialize(answer)
    @answer = answer
    @question = answer.question
  end

  def call
    subscribers = @question.subscribers - [@answer.author]
    subscribers.each do |subscriber|
      SubscriptionMailer.new_answer_notification(@answer, subscriber).deliver_later
      Rails.logger.info "Sending new answer notification async to #{subscriber.email} for question #{@question.id}"
    end
  end
end
