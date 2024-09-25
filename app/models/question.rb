class Question < ApplicationRecord
  include Linkable
  include FileAttachable
  include Authorable

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true

  accepts_nested_attributes_for :reward, allow_destroy: true, reject_if: :all_blank


  validates :title, :body, presence: true

end
