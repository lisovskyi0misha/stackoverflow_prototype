class Vote < ApplicationRecord
  validates_uniqueness_of :answer_id, scope: :user_id
  belongs_to :voted_user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :voted_answer, class_name: 'Answer', foreign_key: 'answer_id'
  enum status: [:liked, :disliked]
end