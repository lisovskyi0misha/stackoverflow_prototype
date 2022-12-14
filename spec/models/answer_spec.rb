require 'rails_helper'

RSpec.describe Answer, type: :model do
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should have_many_attached :files }
  it { should have_many :votes }
  it { should have_many(:voted_users).class_name('User').through(:votes) }
end