class Comment < ApplicationRecord
  include Authorable

  belongs_to :commentable, polymorphic: true
  validates :body, presence: true
  after_create_commit do
    broadcast_prepend_later_to "questions",
                               target: "#{dom_id(commentable, :comments)}",
                               partial: 'comments/comment',
                               locals: { comment: self }

    broadcast_remove_to "questions", target: "#{dom_id(commentable, :no_comments)}"
    broadcast_update_to "questions",
                        target: "#{dom_id(commentable, :form)}",
                        partial: 'comments/comment_button',
                        locals: { commentable: commentable }
  end
  private

  def dom_id(record, prefix = nil)
    ActionView::RecordIdentifier.dom_id(record, prefix)
  end
end
