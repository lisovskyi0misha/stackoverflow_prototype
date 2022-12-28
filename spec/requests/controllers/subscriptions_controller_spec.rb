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

    it 'creates new subscription' do
      expect { post "/questions/#{question.id}/subscriptions" }.to change(question.subscriptions, :count).by(1)
    end

    it 'subscribes right user' do
      post "/questions/#{question.id}/subscriptions"
      expect(question.subscriptions.last).to eq(user.subscriptions.first)
    end
  end
end
