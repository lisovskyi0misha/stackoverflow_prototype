require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    context 'unauthorized user' do
      it 'gets unauthorized error with no access token' do
        get '/api/v1/questions'
        expect(response.status).to eq(401)
      end

      it 'gets unauthorized error with invalid access token' do
        get '/api/v1/questions', params: { access_token: '132456' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized user' do
      let(:user) { create(:user) }
      let(:token) { create(:access_token, resource_owner_id: user.id) }
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

      %w[id title body created_at updated_at].each do |attr|
        it "contains #{attr}" do
          questions.each do |question|
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question_#{question.id}/#{attr}")
          end
        end
      end
    end
  end
end
