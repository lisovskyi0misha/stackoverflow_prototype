module ControllerMacros
  def sign_in_user
    before do
      request&.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
  end

  def return_instance_name
    controller_class.to_s.delete_suffix('Controller').downcase
  end

  def resource
    'question`s show' if return_instance_name == 'answer'
    'new' if return_instance_name == 'question'
  end

  def self.extended(cls)
    cls.include(InstanceMethods)
  end

  module InstanceMethods
    def answers_update_request(answer, body='Changed body')
      put :update, params: { id: answer.id, question_id: answer.question_id, answer: { body: body } }
    end

    def comment_new_request(question, answer = nil)
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
