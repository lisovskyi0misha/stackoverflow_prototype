require 'rails_helper'

describe CommentsController do

  let(:answer) { create(:just_answer) }
  let(:question) { create(:just_question) }
  let(:user) { create(:user) }

  describe 'GET #new_for_answer' do

    it 'creates new comment for answer' do
      comment = answer.comments.build
      get :new_for_answer, params: { answer_id: answer.id }
      expect(assigns(:comment)).to be_a_new(Comment)
      expect(assigns(:comment).commentable_id).to eq(comment.commentable_id)
      expect(assigns(:comment).commentable_type).to eq(comment.commentable_type)
    end

    it 'renders form' do
      get :new_for_answer, params: { answer_id: answer.id }
      expect(response).to render_template :new_for_answer
    end
  end

  describe 'GET #new_for_question' do

    it 'creates new comment for question' do
      comment = question.comments.build
      get :new_for_question, params: { question_id: question.id }
      expect(assigns(:comment)).to be_a_new(Comment)
      expect(assigns(:comment).commentable_id).to eq(comment.commentable_id)
      expect(assigns(:comment).commentable_type).to eq(comment.commentable_type)
    end

    it 'renders form' do
      get :new_for_question, params: { question_id: question.id }
      expect(response).to render_template :new_for_question
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid params' do
      it 'saves answer`s comment to db' do
        expect { post :create,
          params: { 
            comment: { commentable_id: answer.id, commentable_type: 'Answer', body: 'Some comment body' }
          } 
        }.to change(answer.comments, :count).by(1)
      end

      it 'saves question`s comment to db' do
        expect { post :create,
          params: {
            comment: { commentable_id: question.id, commentable_type: 'Question', body: 'Some comment body' }
          } 
        }.to change(question.comments, :count).by(1)
      end

      it 'renders question`s show' do
        post :create, params: { comment: { commentable_id: question.id, commentable_type: 'Question', body: 'Some comment body' } }
        expect(response).to render_template 'questions/show'
      end
    end

    context 'with invalid params' do
      it 'doesn`t save comment to db' do
        expect { post :create,
          params: {
            comment: { commentable_id: question.id, commentable_type: 'Question', body: nil  }
          } 
        }.to_not change(question.comments, :count)
      end
      
      it 're-renders question`s show' do
        post :create, params: { comment: { commentable_id: question.id, commentable_type: 'Question', body: nil } }
        expect(response).to have_http_status(422)
        expect(response).to render_template 'questions/show'
      end
    end
  end

end