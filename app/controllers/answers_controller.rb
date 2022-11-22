class AnswersController < ApplicationController

  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @question = Question.includes(:answers).find_by_id(params[:question_id])
    @answer = @question.answers.create(answer_params)
    respond_to do |format|
      if @answer.valid?
        format.turbo_stream
      else
        @question = Question.includes(:answers).find_by_id(params[:question_id])
        flash[:error] = @answer.errors.full_messages.join(', ')
        format.html { render 'questions/show', status: 422 }
      end
    end
  end

  def destroy
    respond_to do |format| 
      @answer = Answer.find_by_id(params[:id])
      if @answer.user_id == current_user.id
        @answer.destroy
        @question = Question.includes(:answers).find_by_id(params[:question_id])
        format.turbo_stream
      end
      # redirect_to question_path(id: @answer.question_id)
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id, :user_id)
  end

end
