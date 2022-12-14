module Answers
  class DeleteBest
    include ApplicationHelper

    def initialize(answer, owner)
      @answer = answer
      @question = @answer.question
      @old_best_answer = @question.best_answer
      @owner = owner
    end

    def call
      if @owner 
        @question.best_answer = nil
        @question.save
      else
        raise StandardError, 'You can`t delete best answers for other`s questions'
      end
      @old_best_answer
    end
  end
end
