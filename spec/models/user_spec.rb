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
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '12345', info: { email: 'test@test' }) }
    let(:auth_for_existed_user) { OmniAuth::AuthHash.new(provider: 'github', uid: '12345', info: { email: user.email }) }

    context 'user fave already been authorized' do
      it 'returns user' do
        user.providers.create(uid: '12345', provider_name: 'github')
        expect(User.from_omniauth(auth)).to eq(user)
      end
    end

    context 'user haven`t been authorized' do
      context 'user exists' do
        it 'doesn`t save user to db' do

          expect { User.from_omniauth(auth_for_existed_user) }.to_not change(User, :count)
        end

        it 'creates new provider' do
          expect { User.from_omniauth(auth_for_existed_user) }.to change(user.providers, :count).by(1)
        end

        it 'returns user' do
          expect(User.from_omniauth(auth_for_existed_user)).to eq(user)
        end
      end

      context 'user does not exist' do
        it 'saves user to db' do
          expect { User.from_omniauth(auth) }.to change(User, :count).by(1)       
        end

        it 'returns user' do
          user1 = User.from_omniauth(auth)
          expect(user1.email).to eq('test@test')
          expect(user1.providers.first.provider_name).to eq('github')
        end
      end
    end
  end
end
