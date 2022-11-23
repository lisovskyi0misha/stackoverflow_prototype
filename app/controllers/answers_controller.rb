class AnswersController < ApplicationController

  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @question = Question.includes(:answers).find_by_id(params[:question_id])
    @answer = @question.answers.create(answer_params)
    respond_to do |format|
      if @answer.valid?
        format.turbo_stream
      else
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
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@answer) }
      else
        flash[:error] = 'You can`t delete other`s messages'
        format.html { render 'questions/show', status: 422 }
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
