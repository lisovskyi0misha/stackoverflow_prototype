class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, except: :create
  before_action :find_best_answer, only: %i[choose_best delete_best]
  before_action :find_question, only: :create
  respond_to :html
  respond_to :turbo_stream, except: %i[edit update]
  authorize_resource

  def create
    binding.break
    @answer = @question.answers.create(answer_params)
    
    respond_with(@answer) { |format| format.html {render 'questions/show', status: 422 } }
    ActionCable.server.broadcast("question_#{@question.id}", { object: @answer, type: 'answer' }) if @answer.valid?
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def edit; end

  def update
    @answer.update(answer_params)
    respond_with(@answer, location: -> { question_path(@question) })
  end

  def choose_best
    @question.best_answer = @answer
    respond_with(@question.save)
  end

  def delete_best
    @question.best_answer = nil
    @question.save
    respond_with(@question)
  end

  def vote
    respond_with(@answer.votes.create(user_id: current_user.id, status: params[:vote]))
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
end
