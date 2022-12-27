require 'rails_helper'

RSpec.describe Comment do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  subject { Comment.new(user_id: user.id, commentable_id: question.id, commentable_type: 'Question', body: 'Some comment') }

  it { should belong_to :commentable }
  it { should belong_to :user }
  it { should validate_presence_of :body }
end
