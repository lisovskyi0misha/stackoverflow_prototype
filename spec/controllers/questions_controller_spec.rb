require 'rails_helper'

describe QuestionsController do

  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }

  describe 'GET #index' do

    let(:questions) { create_list(:question, 2, user_id: user.id) }
    before { get :index }

    it 'fills array with question objects' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    
    let(:answers) { question.answers }
    before { create_list(:answer, 3, question_id: question.id, user_id: question.user_id) }
    before { get :show, params: { id: question.id } }

    it 'finds object for show' do
      expect(assigns(:question)).to eq(question)
    end

    it 'creates new answer' do
      answers = question.answers.build
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    
    it 'renders show' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'creates new object' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    
    it 'renders new' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, params: { id: question.id } }

    it 'finds object for edit' do
      expect(assigns(:question)).to eq(question)
    end
    
    it 'renders edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new question to db' do
        expect { post :create, params: {question: {user_id: user.id, body: 'Some body', title: 'Some title'}} }.to change(Question, :count).by(1)
      end

      it 'redirects to index' do
        post :create, params: {question: {user_id: user.id, body: 'Some body', title: 'Some title'}}
        expect(response).to redirect_to questions_path
      end
    end

    context 'with invalid attributes' do
      it 'does`t save new question to db' do
        expect { post :create, params: {question: attributes_for(:invalid_question)} }.to_not change(Question, :count)
      end

      it 're-render to new' do
        post :create, params: {question: attributes_for(:invalid_question)}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    sign_in_user

    context 'with valid attributes' do

      it 'finds object for update' do
        put :update, params: {id: question.id, question: attributes_for(:question, user_id: user.id)}
        expect(assigns(:question)).to eq(question)
      end

      it 'updates question' do
        put :update, params: {id: question.id, question: {title: 'changed title', body: 'changed body'}}
        question.reload
        expect(question.title).to eq 'changed title'
        expect(question.body).to eq 'changed body'
      end

      it 'redirects to show' do
        put :update, params: {id: question.id, question: attributes_for(:question, user_id: user.id)}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do

      it 'finds object for update' do
        put :update, params: {id: question.id, question: attributes_for(:question, user_id: user.id)}
        expect(assigns(:question)).to eq(question)
      end

      it 'does`t update question' do
        put :update, params: {id: question.id, question: attributes_for(:invalid_question)}
        expect({title: question.title, body: question.body, user_id: user.id}).to eq(attributes_for(:question, user_id: user.id))
      end

      it 're-render edit' do
        put :update, params: {id: question.id, question: {title: nil, body: nil}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    
    it 'finds object for delete' do
      delete :destroy, params: {id: question.id}
      expect(assigns(:question)).to eq(question)
    end

    it 'deletes question' do
      question.reload
      expect { delete :destroy, params: {id: question.id}}.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: {id: question.id}
      expect(response).to redirect_to questions_path
    end
  end
end
