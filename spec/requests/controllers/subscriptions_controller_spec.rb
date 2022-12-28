require 'rails_helper'

RSpec.describe 'SubscriptionsController' do
  let(:user) { create(:user) }
  let(:question) { create(:just_question) }

  before { sign_in user }

  describe 'POST #create' do
    it 'finds question' do
      post "/questions/#{question.id}/subscriptions"
      expect(assigns(:question)).to eq(question)
    end

    context 'For the first time' do
      it 'creates new subscription' do
        expect { perform_enqueued_jobs { post "/questions/#{question.id}/subscriptions" } }.to change(question.subscriptions, :count).by(1)
      end

      it 'subscribes right user' do
        post "/questions/#{question.id}/subscriptions"
        expect(question.subscriptions.last).to eq(user.subscriptions.first)
      end

      it 'redirects to questions` show' do
        post "/questions/#{question.id}/subscriptions"
        expect(response).to redirect_to question
      end
    end

    context 'for more then a first time' do
      let!(:subscription) { question.subscriptions.create(user_id: user.id) }

      it 'doesn`t create subscription' do
        expect { post "/questions/#{question.id}/subscriptions" }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
