class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(question, user)
    question.subscriptions.create(user_id: user.id)
  end
end
