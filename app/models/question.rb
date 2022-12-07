class Question < ApplicationRecord

  validates_presence_of :title, :body
  has_many :answers
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', required: false
  has_many_attached :files, dependent: :destroy
  has_many :votes, as: :votable
  has_many :voted_users, -> { distinct }, through: :votes

  def rate
    self.votes.liked.count - self.votes.disliked.count
  end
end