require 'rails_helper'

describe CommentsController do
  sign_in_user

  let(:answer) { create(:just_answer) }
  let(:question) { create(:just_question) }
  let(:user) { create(:user) }

  describe 'GET #new_for_answer' do
    before { comment_new_request(question, answer) }

    it 'creates new comment for answer' do
      comment = answer.comments.build
      expect(assigns(:comment)).to be_a_new(Comment)
      expect(assigns(:comment).commentable_id).to eq(comment.commentable_id)
      expect(assigns(:comment).commentable_type).to eq(comment.commentable_type)
    end

    it 'renders form' do
      expect(response).to render_template :new_for_answer
    end
  end

  describe 'GET #new_for_question' do
    before { comment_new_request(question) }

    it 'creates new comment for question' do
      comment = question.comments.build
      expect(assigns(:comment)).to be_a_new(Comment)
      expect(assigns(:comment).commentable_id).to eq(comment.commentable_id)
      expect(assigns(:comment).commentable_type).to eq(comment.commentable_type)
    end

    it 'renders form' do
      expect(response).to render_template :new_for_question
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'saves answer`s comment to db' do
        expect { comment_create_request(question, 'Some comment body', answer) }.to change(answer.comments, :count).by(1)
      end

      it 'saves question`s comment to db' do
        expect { comment_create_request(question, 'Some comment body') }.to change(question.comments, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'doesn`t save comment to db' do
        expect { comment_create_request(question, nil, answer) }.to_not change(question.comments, :count)
      end
      
      it 're-renders question`s show' do
        comment_create_request(question, nil, answer)
        expect(response).to have_http_status(422)
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
