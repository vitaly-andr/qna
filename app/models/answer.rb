class Answer < ApplicationRecord
  include Linkable
  include FileAttachable
  include Authorable
  include Votable

  belongs_to :question

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  validates :body, presence: true

  after_create_commit do
    broadcast_prepend_to "questions", target: "question_#{question.id}_answers", partial: "live_feed/answer", locals: { answer: self }
  end

  after_update_commit do
    broadcast_replace_to "questions", target: "answer_#{id}", partial: "live_feed/answer", locals: { answer: self }
  end

  after_destroy_commit do
    broadcast_remove_to "questions", target: "answer_#{id}"
  end

end
