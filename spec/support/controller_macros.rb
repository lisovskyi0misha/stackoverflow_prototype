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

  end
end
