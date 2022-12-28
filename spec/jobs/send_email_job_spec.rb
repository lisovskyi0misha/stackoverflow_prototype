require 'rails_helper'

RSpec.describe SendEmailJob do
  let(:user) { create(:user) }

  it 'creates job' do
    expect { QuestionMailer.digest_mail(user).deliver_later }.to have_enqueued_job.on_queue('default')
  end

  it 'sends email' do
    expect {
      perform_enqueued_jobs { QuestionMailer.digest_mail(user).deliver_later }
    }.to change(ActionMailer::Base.deliveries, :size).by(1)
  end
end
