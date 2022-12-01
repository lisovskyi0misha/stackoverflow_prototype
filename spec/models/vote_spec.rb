require 'rails_helper'

RSpec.describe Vote do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  subject { Vote.new(user_id: user.id, answer_id: answer.id, status: 0) }
  
  it { should belong_to(:voted_user).class_name('User').with_foreign_key('user_id') }
  it { should belong_to(:voted_answer).class_name('Answer').with_foreign_key('answer_id') }
  it { should define_enum_for(:status).with_values(liked: 0, disliked: 1) }
  it { should validate_uniqueness_of(:answer_id).scoped_to(:user_id) }
end