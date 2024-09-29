class Answer < ApplicationRecord
  include Linkable
  include FileAttachable
  include Authorable
  include Votable

  belongs_to :question

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  validates :body, presence: true
end
