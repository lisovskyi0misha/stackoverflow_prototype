class SubscriptionsController < ApplicationController
  before_action :find_question

  def create
    @question.subscriptions.create(user_id: current_user.id)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
