require 'rails_helper'

RSpec.describe Answer do
  it_behaves_like 'common validations'

  it { should belong_to :question }
end
