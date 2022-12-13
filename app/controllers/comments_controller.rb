class CommentsController < ApplicationController

  def new_for_answer
    @answer = Answer.find_by_id(params[:answer_id])
    @comment = @answer.comments.build
  end

  def new_for_question
    @question = Question.find_by_id(params[:question_id])
    @comment = @question.comments.build
  end

  def create
    @comment = current_user.comments.create(comment_params)
    if @comment.valid?
      render 'questions/show'
    else
      render 'questions/show', status: 422
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :body)
  end
end
