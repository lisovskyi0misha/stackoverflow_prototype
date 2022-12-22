module ControllerMacros
  def sign_in_user
    before do
      request&.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
  end

  def self.extended(cls)
    cls.include(InstanceMethods)
  end

  module InstanceMethods
    def answers_update_request(answer, body='Changed body')
      put :update, params: { id: answer.id, question_id: answer.question_id, answer: {body: body}}
    end

    def answers_create_request(question, body: 'Some body', turbo_stream: true, files: false)
      if turbo_stream
        if files
          post :create, params: {answer: {
            body: body,
            user_id: question.user_id,
            files: [fixture_file_upload('test_file.txt', 'text/plain')]
            }, question_id: question.id }, as: :turbo_stream
        else
          post :create, params: {answer: {body: body, user_id: question.user_id}, question_id: question.id }, as: :turbo_stream
        end
      else
        post :create, params: {answer: {body: body, user_id: question.user_id}, question_id: question.id }
      end
    end

    def answers_vote_request(answer, action='liked')
      post :vote, params: { question_id: answer.question_id, id: answer.id, vote: action }, as: :turbo_stream
    end

    def questions_vote_request(question, action='liked')
      post :vote, params: { id: question.id, vote: action }, as: :turbo_stream
    end

    def comment_new_request(question, answer=nil)
      if answer.nil?
        get :new_for_question, params: { question_id: question.id }
      else
        get :new_for_answer, params: { question_id: question.id, answer_id: answer.id } 
      end
    end

    def comment_create_request(question, body, answer=nil)
      if answer.nil?
        post :create, params: { comment: { commentable_id: question.id, commentable_type: 'Question', body: body }, question_id: question.id } 
      else
        post :create, params: { comment: { commentable_id: answer.id, commentable_type: 'Answer', body: body }, question_id: question.id }
      end
    end
  end
end
