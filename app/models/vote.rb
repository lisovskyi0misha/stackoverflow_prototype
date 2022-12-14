class Vote < ApplicationRecord
  validates_uniqueness_of :user_id, scope: [:votable_id, :votable_type]
  belongs_to :voted_user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :votable, polymorphic: true
  # belongs_to :answer, -> { where votable_type: 'Answer'}
  # belongs_to :question, -> { where votable_type: 'Question'}
  enum status: [:liked, :disliked]
end