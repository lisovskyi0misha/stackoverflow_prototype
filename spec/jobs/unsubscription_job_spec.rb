require 'rails_helper'

RSpec.describe UnsubscriptionJob do
  let!(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, { user: }) }
  let!(:subscription) { question.subscriptions.create(user_id: user.id) }

  it 'creates job' do
    expect { UnsubscriptionJob.perform_later(subscription) }.to have_enqueued_job.on_queue('default')
  end

  it 'deletes object from db' do
    expect { UnsubscriptionJob.perform_now(subscription) }.to change(question.subscriptions, :count).by(-1)
  end
end
