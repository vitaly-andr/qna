class Question < ApplicationRecord
  include Linkable
  include FileAttachable
  include Authorable
  include Votable
  before_destroy :reset_best_answer


  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :reward, allow_destroy: true, reject_if: :all_blank


  validates :title, :body, presence: true

  private

  def reset_best_answer
    self.best_answer = nil
  end

end
