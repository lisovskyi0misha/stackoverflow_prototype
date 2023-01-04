class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[edit update destroy vote]
  before_action :find_question_with_answers, only: [:show]

  authorize_resource

  def index
    @q = Question.ransack(params[:q])
    @questions = @q.result(distinct: true)
  end

  def show
    @q = @question.answers.ransack(params[:q])
    @answer = @question.answers.build
    @answers = @q.result
    @subscription = @question.current_subscription(current_user) if has_subscription?(@question)
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    if @question.valid?
      flash[:success] = 'Your question was successfully created'
      redirect_to questions_path
      ActionCable.server.broadcast('question-index', @question)
    else
      flash[:error] = @question.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @question.user_id != current_user&.id
      redirect_to question_path(@question)
      return
    end
    @question.update(question_params) ? redirect_to(question_path(@question)) : render(:edit, status: 422)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def vote
    @question.votes.create(user_id: current_user.id, status: params[:vote])
    respond_to { |format| format.turbo_stream }
  end

  private

  def find_question
    @question = Question.find_by_id(params[:id])
  end

  def find_question_with_answers
    @question = Question.includes(
      { answers: %i[votes voted_users comments] },
      :comments,
      :best_answer
    ).find_by_id(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, files: [])
  end
end
