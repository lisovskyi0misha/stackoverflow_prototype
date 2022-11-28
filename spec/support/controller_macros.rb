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

    def answers_create_request(question, body='Some body', turbo_stream)
      if turbo_stream
        post :create, params: {answer: {body: body, user_id: question.user_id}, question_id: question.id }, as: :turbo_stream
      else
        post :create, params: {answer: {body: body, user_id: question.user_id}, question_id: question.id }
      end
    end
  end
end
