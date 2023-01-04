require 'rails_helper'

describe Subscription do
  let(:user) { create(:user) }
  let(:question) { create(:question, { user: }) }
  subject { question.subscriptions.create(user_id: user.id) }

  it { should belong_to :subscribed_user }
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
end
