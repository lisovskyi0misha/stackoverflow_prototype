class Question < ApplicationRecord
  validates_presence_of :title, :body
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', required: false
  belongs_to :user
  has_many_attached :files, dependent: :destroy
  has_many :answers,  dependent: :destroy
  has_many :comments, as: :commentable
  has_many :votes, as: :votable
  has_many :voted_users, -> { distinct }, through: :votes

  def rate
    votes.liked.count - votes.disliked.count
  end

  def file_urls
    files.collect { |file| Rails.application.routes.url_helpers.rails_blob_url(file, host: 'localhost:3000') }
  end
end
