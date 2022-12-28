require 'rails_helper'

describe Subscription do
  it { should belong_to :subscribed_user }
end
