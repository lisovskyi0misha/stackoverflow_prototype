require 'rails_helper'

RSpec.describe Question do
  it_behaves_like 'common validations'

  it { should validate_presence_of :title }
  it { should have_many :answers }

  describe '.send_daily_email' do
    let!(:user) { create(:user) }

    it 'creates job' do
      expect { Question.send_daily_email }.to have_enqueued_job.on_queue('default')
    end

    it 'sends email' do
      expect {
        perform_enqueued_jobs { Question.send_daily_email }
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end
end
