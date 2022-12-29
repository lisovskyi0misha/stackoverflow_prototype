class UnsubscriptionJob < ApplicationJob
  queue_as :default

  def perform(subscription)
    Subscription.destroy(subscription.id)
  end
end
