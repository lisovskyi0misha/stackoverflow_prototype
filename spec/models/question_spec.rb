require 'rails_helper'

RSpec.describe Question do
  it_behaves_like 'common validations'

  it { should validate_presence_of :title }
  it { should have_many :answers }
end
