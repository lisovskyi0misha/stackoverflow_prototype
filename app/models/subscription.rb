class Subscription < ApplicationRecord
  belongs_to :subscribed_user, class_name: 'User', foreign_key: 'user_id'
end
