class Question < ApplicationRecord

  validates_presence_of :title, :body
  has_many :answers
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', required: false
  has_many_attached :files, dependent: :destroy
end