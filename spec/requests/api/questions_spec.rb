require 'rails_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET #index' do
    get_unauthorized_user_context

    context 'authorized user' do
      let!(:questions) { create_list(:just_question, 3) }

      before { get '/api/v1/questions', params: { access_token: token.token } }

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      it 'returns list of questions' do
        questions.each do |question|
          expect(response.body).to be_json_eql(question.to_json).at_path("question_#{question.id}")
        end
      end

      %w[id title body created_at updated_at user_id].each do |field|
        it "contains #{field}" do
          questions.each do |question|
            path = "question_#{question.id}/#{field}"
            expect(response.body).to be_json_eql(question.send(field.to_sym).to_json).at_path(path)
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:just_question) }

    get_unauthorized_user_context(':id')

    context 'authorized user' do
      before { get "/api/v1/questions/#{question.id}", params: { access_token: token.token } }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'renders question' do
        expect(response.body).to be_json_eql(question.to_json).at_path('question')
      end

      context 'comments' do
        let!(:comment) { create(:questions_comment, commentable: question) }

        before { get "/api/v1/questions/#{question.id}", params: { access_token: token.token } }

        it 'includes comments' do
          expect(response.body).to be_json_eql(question.comments.to_json).at_path('comments')
        end

        %w[body created_at updated_at user_id].each do |field|
          it "includes #{field}" do
            path = "comments/0/#{field}"
            expect(response.body).to be_json_eql(question.comments.first.send(field.to_sym).to_json).at_path(path)
          end
        end
      end

      it 'includes attached files' do
        expect(response.body).to be_json_eql(question.file_urls.to_json).at_path('files')
      end
    end
  end

  describe 'POST #create' do
    post_unauthorized_user_context

    context 'authorized user' do
      let(:valid_params) { { access_token: token.token, question: attributes_for(:question, user_id: user.id) } }
      let(:invalid_params) { { access_token: token.token, question: attributes_for(:invalid_question, user_id: user.id) } }
      let(:question) { create(:question, user_id: user.id) }

      it 'returns status 200' do
        post '/api/v1/questions/', params: valid_params
        expect(response.status).to eq(200)
      end

      context 'with valid params' do
        it 'saves question to db' do
          expect { post '/api/v1/questions/', params: valid_params }.to change(Question, :count).by(1)
        end

        it 'returns question' do
          post '/api/v1/questions/', params: valid_params
          expect(response.body).to be_json_eql(question.to_json)
        end
      end

      context 'with invalid params' do
        it 'doesn`t save question to db' do
          expect { post '/api/v1/questions/', params: invalid_params }.to_not change(Question, :count)
        end

        it 'returns status 422' do
          post '/api/v1/questions/', params: invalid_params
          expect(response.status).to eq(422)
        end

        it 'returns error message' do
          post '/api/v1/questions/', params: invalid_params
          message = "Title can't be blank\nBody can't be blank"
          expect(response.body).to be_json_eql(message.to_json).at_path('message')
        end
      end
    end
  end
end
