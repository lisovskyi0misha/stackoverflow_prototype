require 'rails_helper'

describe AnswersController do

  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  sign_in_user

  describe 'POST #create', turbo: true do
    context 'with valid attributes' do

      it 'creates answer' do
        expect { post :create, params: {answer: {
          body: 'Some body',
          question_id: question.id,
          user_id: question.user_id
          }} }.to change(question.answers, :count).by(1)
      end

      it 'renders question page' do
        post :create, params: {answer: {body: 'Some body', user_id: question.user_id}, question_id: question.id }, as: :turbo_stream
        expect(response).to render 'questions/show'
      end
    end

    context 'with invalid attributes' do

      it 'creates answer' do
        expect { post :create, params: {answer: {body: nil, question_id: question.id}}, xhr: true  }.to_not change(question.answers, :count)
      end

      it 'redirects to question page' do
        post :create, params: {answer: {body: nil, question_id: question.id}}, xhr: true 
        expect(response).to redirect_to question_path(id: question.id)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
    context 'user`s own answer' do

      it 'finds answer' do
        delete :destroy, params: {id: answer.id}
        expect(assigns(:answer)).to eq(answer)
      end

      it 'deletes answer' do
        answer
        expect { delete :destroy, params: {id: answer.id} }.to change(question.answers, :count).by(-1)
      end
  end
    context 'other user`s answer' do
      let(:user_with_answer) { create(:user) }
      let(:another_person_question) { create(:question, user_id: user_with_answer.id)}
      let(:another_person_answer) { create(:answer, question_id: another_person_question.id, user_id: user_with_answer.id)}

      it 'finds answer' do
        delete :destroy, params: {id: answer.id}
        expect(assigns(:answer)).to eq(answer)
      end

      it 'doesn`t delete answer' do
        another_person_answer
        expect { delete :destroy, params: {id: another_person_answer.id} }.to_not change(question.answers, :count)
      end
    end
  end
end
