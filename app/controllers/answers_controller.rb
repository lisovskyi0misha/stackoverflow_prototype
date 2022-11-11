class AnswersController < ApplicationController

  def index
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.create(answer_params)
    if @answer.valid?
      redirect_to answers_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
