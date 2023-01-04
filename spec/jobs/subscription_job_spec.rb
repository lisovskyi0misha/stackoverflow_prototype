require 'rails_helper'

RSpec.describe SubscriptionJob do
  let!(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, { user: }) }

  it 'creates job' do
    expect { SubscriptionJob.perform_later(question, another_user) }.to have_enqueued_job.on_queue('default')
  end

  context 'subscription doesn`t exist' do
    it 'saves object to db' do
      expect { SubscriptionJob.perform_now(question, another_user) }.to change(question.subscriptions, :count).by(1)
    end
  end

  context 'subscription exists' do
    it 'doesn`t save object to db' do
      SubscriptionJob.perform_now(question, user)
      expect { SubscriptionJob.perform_now(question, user) }.to_not change(question.subscriptions, :count)
    end
  end
end
