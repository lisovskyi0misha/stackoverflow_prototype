class Answer < ApplicationRecord
  include ModelHelper

  after_create :question_update_mail

  validates_presence_of :body
  belongs_to :question
  belongs_to :user
  has_many_attached :files
  has_many :comments, as: :commentable
  has_many :votes, as: :votable
  has_many :voted_users, -> { distinct }, through: :votes

  private

  def question_update_mail
    question = self.question
    users = question.subscribed_users
    send_mails(users, question)
  end

  def send_mails(users, question)
    users.each do |user|
      QuestionMailer.update_mail(user, question, self).deliver_later
    end
  end
end
