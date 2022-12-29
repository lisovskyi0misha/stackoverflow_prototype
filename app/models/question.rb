class Question < ApplicationRecord
  include ModelHelper

  after_create :subscribe

  validates_presence_of :title, :body
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', required: false
  belongs_to :user
  has_many_attached :files, dependent: :destroy
  has_many :answers,  dependent: :destroy
  has_many :comments, as: :commentable
  has_many :votes, as: :votable
  has_many :voted_users, -> { distinct }, through: :votes
  has_many :subscriptions
  has_many :subscribed_users, class_name: 'User', through: :subscriptions

  scope :for_the_last_day, -> { where(created_at: Date.yesterday) }

  def self.send_daily_email
    User.find_each do |user|
      QuestionMailer.digest_mail(user).deliver_later
    end
  end

  def current_subscription(user)
    subscriptions.where(user_id: user&.id).first
  end

  private

  def subscribe
    SubscriptionJob.perform_later(self, user)
  end
end
