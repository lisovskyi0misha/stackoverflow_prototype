module Answers
  class DeleteBest

    def initialize(answer, user)
      @answer = answer
      @question = @answer.question
      @old_best_answer = @question.best_answer
      @user_id = user.id
    end

    def call
      if @user_id == @question.user_id
        @question.best_answer = nil
        @question.save
      else
        raise StandardError, 'You can`t delete best answers for other`s questions'
      end
      @old_best_answer
    end
  end
end
