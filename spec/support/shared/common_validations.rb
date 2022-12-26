RSpec.shared_examples 'common validations' do
  it { should validate_presence_of :body }
  it { should have_many_attached :files }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many(:voted_users).class_name('User').through(:votes) }
end
