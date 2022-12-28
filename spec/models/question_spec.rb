require 'rails_helper'

RSpec.describe Question do
  it_behaves_like 'common validations'

  it { should validate_presence_of :title }
  it { should have_many :answers }
  it { should have_many :subscriptions }
  it { should have_many(:subscribed_users).through(:subscriptions).class_name('User') }

  describe '.send_daily_email' do
    let!(:user) { create(:user) }

    it 'creates job' do
      expect { Question.send_daily_email }.to have_enqueued_job.on_queue('default')
    end

    it 'sends email' do
      expect do
        perform_enqueued_jobs { Question.send_daily_email }
      end.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end

  describe '#subscribe' do
    let(:user) { create(:user) }

    it 'creates new subscription' do
      expect { perform_enqueued_jobs { create(:just_question, { user: }) } }.to change(user.subscriptions, :count).by(1)
    end

    it 'subscribed user to his question' do
      question = create(:just_question, { user: })
      expect(question.subscriptions).to eq(user.subscriptions)
    end
  end
end
