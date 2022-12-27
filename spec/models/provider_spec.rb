require 'rails_helper'

RSpec.describe Provider do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider_name }
  it { should belong_to :user }
end
