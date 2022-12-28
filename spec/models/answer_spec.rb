require 'rails_helper'

RSpec.describe Answer do
  it_behaves_like 'common validations'

  it { should belong_to :question }

  describe '#question_update_mail' do
    let!(:user) { create(:user) }
    let(:question) { create(:question, user_id: user.id) }
    let(:subscription) { question.subscriptions.create({ user_id: })}
    let(:method) { create(:just_answer, { question: }) }

    it 'sends email' do
      expect {
        perform_enqueued_jobs { method }
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it 'creates job' do
      expect { method }.to have_enqueued_job.on_queue('default')
    end

    it 'sends email to user with subscription' do
      perform_enqueued_jobs { method }
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to.first).to eq(user.email)
    end
  end
end
