class Subscription < ApplicationRecord
  belongs_to :subscribed_user, class_name: 'User', foreign_key: 'user_id'
  validates_uniqueness_of :user_id, scope: :question_id
end
