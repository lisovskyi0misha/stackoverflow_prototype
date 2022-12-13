class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  validates_presence_of :body
  validates_uniqueness_of :user_id, scope: [:commentable_id, :commentable_type] 
end
