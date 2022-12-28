require 'rails_helper'

RSpec.describe Answer do
  it_behaves_like 'common validations'

  it { should belong_to :question }

  describe '#question_update_mail' do
    let!(:user) { create(:user) }
    let(:users) { create_list(:user, 3) }
    let(:question) { create(:just_question, { user: }) }
    let(:subscriptions) { users.each { |another_user| question.subscriptions.create({ user_id: another_user.id }) } }
    let(:method) { create(:just_answer, { question: }) }

    it 'sends email' do
      expect {
        perform_enqueued_jobs { method }
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it 'creates job' do
      expect { method }.to have_enqueued_job.on_queue('default')
    end

    it 'sends email only to users with subscription' do
      subscriptions
      user.subscriptions.destroy_all
      perform_enqueued_jobs { method }
      users.each_with_index do |another_user, ind|
        mail = ActionMailer::Base.deliveries[ind]
        expect(mail.to.first).to_not eq(user.email)
        expect(mail.to.first).to eq(another_user.email)
      end
    end
  end
end
