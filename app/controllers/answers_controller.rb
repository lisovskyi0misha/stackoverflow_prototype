class AnswersController < ApplicationController

  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @answer = Answer.new(answer_params)
    @answer.user_id = current_user.id
    respond_to do |format| 
      if @answer.save
        @question = Question.includes(:answers).find_by_id(params[:answer][:question_id])
        # flash[:success] = 'Answer was succesfully created'
        format.turbo_stream
      else
        flash[:error] = @answer.errors.full_messages.join(', ')
      end
    end
  end

  def destroy
    @answer = Answer.find_by_id(params[:id])
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:success] = 'Answer has been succesfully deleted'
    end
    redirect_to question_path(id: @answer.question_id)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
