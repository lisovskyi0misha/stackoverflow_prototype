require 'rails_helper'

describe Subscription do
  it { should belong_to :subscribed_user }
  it { should validate_uniqueness_of(:user_id).scope(:question_id) }
end
