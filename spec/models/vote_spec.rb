require 'rails_helper'

RSpec.describe Vote do
  it { should belong_to(:voted_user).class_name('User').with_foreign_key('user_id') }
  it { should belong_to(:voted_answer).class_name('Answer').with_foreign_key('answer_id') }
  it { should define_enum_for(:status).with_values(liked: 0, disliked: 1) }
end