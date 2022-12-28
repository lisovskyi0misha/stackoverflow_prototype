class Answer < ApplicationRecord
  include ModelHelper

  validates_presence_of :body
  belongs_to :question
  belongs_to :user
  has_many_attached :files
  has_many :comments, as: :commentable
  has_many :votes, as: :votable
  has_many :voted_users, -> { distinct }, through: :votes

  after_create :question_update_mail

  private

  def question_update_mail
    question = self.question
    user = question.user
    QuestionMailer.update_mail(user, question, self).deliver_later
  end
end
