class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :choose_best, :vote]
  before_action :find_answer, except: [:create]

  def create
    @question = Question.includes(:answers, :best_answer).find_by_id(params[:question_id])
    @answer = @question.answers.create(answer_params)
    respond_to do |format|
      if @answer.valid?
        format.turbo_stream
        ActionCable.server.broadcast("question_#{@question.id}",{object: @answer, type: 'answer'})
      else
        flash[:error] = @answer.errors.full_messages.join(', ')
        format.html { render 'questions/show', status: 422 }
      end
    end
  end

  def destroy
    respond_to do |format|
      if owner?(@answer.user_id)
        @answer.destroy
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@answer) }
      else
        flash[:error] = 'You can`t delete other`s messages'
        format.html { render 'questions/show', status: 422 }
      end
    end
  end

  def edit
  end

  def update
    if owner?(@answer.user_id)
      return redirect_to question_path(@answer.question) if @answer.update(answer_params)
      flash[:error] = @answer.errors.full_messages.join(', ')
      render :edit, status: 422
    else
      flash[:error] = 'You can`t edit other`s questions'
      redirect_to question_path(@answer.question)
    end
  end

  def choose_best
    @old_best_answer = @question.best_answer
    return redirect_to question_path(@question) unless owner?(@question.user_id)
    @question.best_answer = @answer
    @question.save
    respond_to { |format| format.turbo_stream }
  end

  def delete_best
    @old_best_answer = Answers::DeleteBest.new(@answer, owner?(@answer.question.user_id)).call
    respond_to { |format| format.turbo_stream }
  rescue StandardError => e
    flash[:error] = e.message
    render 'questions/show', status: 422
  end

  def vote
    @answer.votes.create(user_id: current_user.id, status: params[:vote]) unless owner?(@answer.user_id)
    respond_to { |format| format.turbo_stream }
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :user_id, files: [])
  end

  def find_answer
    @answer = Answer.includes(:question).find_by_id(params[:id])
    @question = @answer.question
  end
end
