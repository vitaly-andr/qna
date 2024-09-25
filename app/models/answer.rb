class Answer < ApplicationRecord
  include Linkable
  include FileAttachable
  include Authorable

  belongs_to :question

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true
end
