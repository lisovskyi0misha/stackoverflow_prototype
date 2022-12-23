require 'rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET #index' do
    unauthorized_user_context(':id/answers')

    context 'authorized user' do
      let(:question) { create(:just_question) }
      let!(:answers) { create_list(:just_answer, 3, question_id: question.id) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: token.token } }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'returns question`s answers' do
        expect(response.body).to be_json_eql(answers.to_json)
      end

      %w[body created_at updated_at].each do |field|
        it "contails #{field}" do
          expect(response.body).to be_json_eql(answers.first.send(field.to_sym).to_json).at_path("0/#{field}")
        end
      end
    end
  end
end
