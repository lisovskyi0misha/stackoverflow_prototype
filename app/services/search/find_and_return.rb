module Search
  class FindAndReturn
    def initialize(params)
      @q = params[:q]
    end

    def call
      find_users
      find_questions
      find_answers
      find_comments
      hash_objects
    end

    private

    def find_users
      @users = User.ransack(email_cont: @q).result
    end

    def find_questions
      @questions = Question.ransack(title_or_body_cont: @q).result
    end

    def find_answers
      @answers = Answer.ransack(@q).result
    end

    def find_comments
      @comments = Comment.ransack(@q).result
    end

    def hash_objects
      @results = { users: @users, questions: @questions, answers: @answers, comments: @comments }
    end
  end
end
