class Answer < ApplicationRecord
  validates_presence_of :body
  belongs_to :question
  has_many_attached :files
  has_many :votes
  has_many :voted_users, -> { distinct }, through: :votes

  def rate
    self.votes.liked.count - self.votes.disliked.count
  end
end
