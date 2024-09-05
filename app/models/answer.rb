class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true
  validates :question, presence: true
  validates :author, presence: true

end
