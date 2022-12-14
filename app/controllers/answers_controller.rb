class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, except: [:create]
  before_action :find_best_answer, only: [:choose_best, :delete_best]
  before_action :find_question, only: :create
  before_action :check_if_owner, only: [:update]
  respond_to :html
  respond_to :turbo_stream, except: [:edit, :update]

  def create
    @answer = @question.answers.create(answer_params)
    respond_with(@answer) { |format| format.html {render 'questions/show', status: 422 } }
    ActionCable.server.broadcast("question_#{@question.id}",{object: @answer, type: 'answer'}) if @answer.valid?
  end

  def destroy
    return respond_with(@answer.destroy) if owner?(@answer.user_id)
    render 'questions/show', status: 422
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer, location: -> { question_path(@question) })
  end

  def choose_best
    return redirect_to @question unless owner?(@question.user_id)
    @question.best_answer = @answer
    respond_with(@question.save)
  end

  def delete_best
    @question.best_answer = nil if owner?(@question.user_id)
    @question.save
    respond_with(@question)
  end

  def vote
    respond_with(@answer.votes.create(user_id: current_user.id, status: params[:vote])) unless owner?(@answer.user_id)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :user_id, files: [])
  end

  def find_answer
    @answer = Answer.includes(:question).find_by_id(params[:id])
    @question = @answer.question
  end

  def find_best_answer
    @old_best_answer = @question.best_answer
  end

  def find_question
    @question = Question.includes(:answers, :best_answer).find_by_id(params[:question_id])
  end

  def check_if_owner
    return redirect_to question_path(@question) unless owner?(@answer.user_id)
  end
end
