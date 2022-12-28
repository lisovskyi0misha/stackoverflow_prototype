class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  def create
    SubscriptionJob.perform_later(@question, current_user)
    flash[:success] = 'You`ve been succesfully subscribes'
    redirect_to @question
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    return unless has_subscription?(@question)

    Subscription.destroy(@subscription.id)
    flash[:success] = 'You`ve been successfully unsubscribed from question'
    redirect_to @question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
