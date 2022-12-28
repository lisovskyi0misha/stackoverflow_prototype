class SubscriptionsController < ApplicationController
  before_action :find_question

  def create
    SubscriptionJob.perform_later(@question, current_user)
    @answer = @question.answer.build
    flash[:success] = 'You`ve been succesfully subscribes'
    redirect_to @question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
