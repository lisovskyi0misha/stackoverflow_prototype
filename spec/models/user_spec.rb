require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many :providers }

  describe '.from_omniauth' do
    context 'user fave already been authorized'
    
    context 'user haven`t been authorized'
  end
end
