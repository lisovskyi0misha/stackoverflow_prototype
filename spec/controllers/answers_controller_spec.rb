require 'rails_helper'

describe AnswersController do

  describe 'GET #new' do

    before { get :new }

    it 'creates new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do

      let(:question) { create(:question) }

      it 'creates answer' do
        expect { post :create, params: {answer: {body: 'Some body', question_id: question.id}} }.to change(Answer, :count).by(1)
      end

      it 'redirects to index' do
        post :create, params: {answer: {body: 'Some body', question_id: question.id}}
        expect(response).to redirect_to answers_path
      end
    end

    context 'with invalid attributes' do

      let(:question) { create(:question) }

      it 'creates answer' do
        expect { post :create, params: {answer: {body: nil, question_id: question.id}} }.to_not change(Answer, :count)
      end

      it 're-renders new' do
        post :create, params: {answer: {body: nil, question_id: question.id}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template :new
      end
    end
  end
end
