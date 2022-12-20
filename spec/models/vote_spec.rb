require 'rails_helper'

RSpec.describe Vote, type: :model do
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  subject { Vote.new(user_id: user.id, votable_id: answer.id, votable_type: 'Answer', status: 0) }

  it { should belong_to(:voted_user).class_name('User').with_foreign_key('user_id') }
  it { should define_enum_for(:status).with_values(liked: 0, disliked: 1) }
  it { should validate_uniqueness_of(:user_id).scoped_to(%i[votable_id votable_type]) }
  it { should belong_to(:votable) }
end
