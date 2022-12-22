class Answer < ApplicationRecord
  validates_presence_of :body
  belongs_to :question
  belongs_to :user
  has_many_attached :files
  has_many :comments, as: :commentable
  has_many :votes, as: :votable
  has_many :voted_users, -> { distinct }, through: :votes

  def rate
    self.votes.liked.count - self.votes.disliked.count
  end
end
