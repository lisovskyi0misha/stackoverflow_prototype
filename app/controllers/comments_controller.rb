class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question
  authorize_resource

  def new_for_answer
    @answer = Answer.find_by_id(params[:answer_id])
    @comment = @answer.comments.build
  end

  def new_for_question
    @comment = @question.comments.build
  end

  def create
    @comment = current_user.comments.create(comment_params)
    if @comment.valid?
      ActionCable.server.broadcast("question_#{@question.id}", { object: @comment, type: 'comment' })
    else
      @answer = @question.answers.build
      flash[:error] = @comment.errors.full_messages.join(', ')
      render 'questions/show', status: 422
    end
  end

  def index
    @commentable_ids = @question.answers.ids << @question.id
    @q = Comment.where(commentable_id: @commentable_ids).ransack(params[:q])
    @comments = @q.result
  end

  private

  def find_question
    @question = Question.find_by_id(params[:question_id])
  end

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :body)
  end
end
