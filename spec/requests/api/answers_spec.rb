require 'rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:token) { create(:access_token, resource_owner_id: user.id) }
  let(:question) { create(:just_question) }

  describe 'GET #index' do
    unauthorized_user_context(':id/answers')

    context 'authorized user' do
      let!(:answers) { create_list(:just_answer, 3, question_id: question.id) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: token.token } }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'returns question`s answers' do
        expect(response.body).to be_json_eql(answers.to_json)
      end

      %w[body created_at updated_at user_id].each do |field|
        it "contails #{field}" do
          expect(response.body).to be_json_eql(answers.first.send(field.to_sym).to_json).at_path("0/#{field}")
        end
      end
    end
  end

  describe 'GET #show' do
    unauthorized_user_context(':question_id/answers/:id')
  end

  context 'authorized' do
    let(:answer) { create(:just_answer, question_id: question.id) }
    let!(:comments) { create_list(:answers_comment, 3, commentable_id: answer.id) }

    before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { access_token: token.token } }

    it 'returns answer' do
      expect(response.body).to be_json_eql(answer.to_json).at_path('answer')
    end

    context 'comments' do
      it 'contains answer`s comments' do
        expect(response.body).to be_json_eql(comments.to_json).at_path('comments')
      end

      %w[body created_at updated_at user_id].each do |field|
        it "contains #{field}" do
          expect(response.body).to be_json_eql(comments.first.send(field.to_sym).to_json).at_path("comments/0/#{field}")
        end
      end
    end

    it 'contains file urls' do
      expect(response.body).to be_json_eql(answer.file_urls.to_json).at_path('files')
    end
  end
end
