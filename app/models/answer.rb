class Answer < ApplicationRecord
  include Linkable
  include FileAttachable
  include Authorable
  include Votable
  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :question

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  validates :body, presence: true

  after_create_commit do
    broadcast_prepend_to "questions", target: "question_#{question.id}_answers", partial: "live_feed/answer", locals: { answer: self }
  end

  after_update_commit do
    broadcast_update_to "questions",
                        target: "#{dom_id(self)}",
                        partial: "live_feed/answer",
                        locals: { answer: self }
  end

  after_destroy_commit do
    broadcast_remove_to "questions", target: "answer_#{id}"
  end
  private

  def dom_id(record, prefix = nil)
    ActionView::RecordIdentifier.dom_id(record, prefix)
  end
end
