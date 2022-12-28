class SubscriptionsController < ApplicationController
  before_action :find_question
  authorize_resource

  def create
    @question.subscriptions.create!(user_id: current_user.id)
    flash[:success] = 'You`ve been succesfully subscribes'
    redirect_to @question
  rescue ActiveRecord::RecordInvalid
    @answer = @question.answers.build
    render 'questions/show', status: 422
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
