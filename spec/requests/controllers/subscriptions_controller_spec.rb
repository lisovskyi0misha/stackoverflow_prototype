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
        expect do
          perform_enqueued_jobs { post "/questions/#{question.id}/subscriptions" }
        end.to change(question.subscriptions, :count).by(1)
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
      let!(:subscription) { create(:subscription, { question:, subscribed_user: user }) }

      it 'doesn`t create subscription' do
        expect { post "/questions/#{question.id}/subscriptions" }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, { question:, subscribed_user: user }) }
    let!(:other_subscription) { create(:subscription, { question:, subscribed_user: create(:user) }) }

    it 'finds question' do
      delete "/questions/#{question.id}/subscriptions/#{subscription.id}"
      expect(assigns(:question)).to eq(question)
    end

    context 'subscribed user tries to unsubscribe' do
      it 'finds subscription' do
        delete "/questions/#{question.id}/subscriptions/#{subscription.id}"
        expect(assigns(:subscription)).to eq(subscription)
      end

      it 'deletes subscription' do
        expect do
          perform_enqueued_jobs do
            delete "/questions/#{question.id}/subscriptions/#{subscription.id}" 
          end
        end.to change(user.subscriptions, :count).by(-1)
      end
    end

    context 'non-subscribed user tries to unsubscribe' do
      it 'finds subscription' do
        delete "/questions/#{question.id}/subscriptions/#{other_subscription.id}"
        expect(assigns(:subscription)).to eq(other_subscription)
      end

      it 'doesn`t delete subscription' do
        expect { delete "/questions/#{question.id}/subscriptions/#{other_subscription.id}" }.to_not change(user.subscriptions, :count)
      end
    end
  end
end
