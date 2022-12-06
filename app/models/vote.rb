class Vote < ApplicationRecord
  validates_uniqueness_of :user_id, scope: [:votable_id, :votable_type]
  belongs_to :voted_user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :voted_answer, class_name: 'Answer', foreign_key: 'answer_id'
  belongs_to :votable, polymorphic: true
  enum status: [:liked, :disliked]
end