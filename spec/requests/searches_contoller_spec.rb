require 'rails_helper'

describe 'SearchController' do
  describe 'GET #show' do
    let!(:user) { create(:user, email: 'ransack@mail') }
    let!(:question) { create(:just_question, title: 'ransack test') }
    let!(:answer) { create(:just_answer, body: 'ransack test body') }
    let!(:comment) { create(:questions_comment, body: 'ransack test body') }
    let(:another_question) { create(:just_question, body: 'ransack test body') }

    %w[user question answer comment].each do |object|
      it "finds #{object}s" do
        get '/search', params: { q: 'ransack' }
        expect(assigns(:results)["#{object}s".to_sym]).to eq([send(object.to_sym)])
      end
    end

    it 'finds question by body' do
      another_question
      get '/search', params: { q: 'ransack' }
      expect(assigns(:results)[:questions]).to eq([question, another_question])
    end
  end
end
