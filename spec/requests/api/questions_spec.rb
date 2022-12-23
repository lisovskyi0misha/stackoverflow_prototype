require 'rails_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET #index' do
    unauthorized_user_context

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

      %w[id title body created_at updated_at].each do |field|
        it "contains #{field}" do
          questions.each do |question|
            expect(response.body).to be_json_eql(question.send(field.to_sym).to_json).at_path("question_#{question.id}/#{field}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:just_question) }

    unauthorized_user_context(':id')

    context 'authorized user' do
      before { get "/api/v1/questions/#{question.id}", params: { access_token: token.token } }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'renders question' do
        expect(response.body).to be_json_eql(question.to_json).at_path('question')
      end

      context 'comments' do
        let!(:comment) { create(:questions_comment, commentable_id: question.id) }

        before { get "/api/v1/questions/#{question.id}", params: { access_token: token.token } }

        it 'includes comments' do
          expect(response.body).to be_json_eql(question.comments.to_json).at_path('comments')
        end

        %w[body created_at updated_at].each do |field|
          it "includes #{field}" do
            expect(response.body).to be_json_eql(question.comments.first.send(field.to_sym).to_json).at_path("comments/0/#{field}")
          end
        end
      end

      it 'includes attached files' do
        expect(response.body).to be_json_eql(question.file_urls.to_json).at_path('files')
      end
    end
  end
end
