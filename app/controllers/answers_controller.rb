class AnswersController < ApplicationController

  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    binding.break
    @answer = Answer.new(answer_params)
    @answer.user_id = current_user.id
    @question = Question.includes(:answers).find_by_id(params[:answer][:question_id])
    if @answer.save
      # flash[:success] = 'Answer was succesfully created'
      respond_to do |format|
        # format.html { redirect_to '/questions/1' }
        format.js {
          render :create
        }
      end
    else
      flash[:error] = @answer.errors.full_messages.join(', ')
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
