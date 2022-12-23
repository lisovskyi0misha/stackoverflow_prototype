class Question < ApplicationRecord
  include ModelHelper

  validates_presence_of :title, :body
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', required: false
  belongs_to :user
  has_many_attached :files, dependent: :destroy
  has_many :answers,  dependent: :destroy
  has_many :comments, as: :commentable
  has_many :votes, as: :votable
  has_many :voted_users, -> { distinct }, through: :votes
end
