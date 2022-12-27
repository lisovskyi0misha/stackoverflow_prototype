class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :twitter2]
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :providers

  def self.from_omniauth(auth)
    provider_params = { provider_name: auth.provider, uid: auth.uid }
    if provider = Provider.find_by(provider_params)
      user = provider.user
    else
      user = user_exist?(auth, provider_params)
      return user if user
      create_new_user(auth, provider_params)
    end
  end

  private

  def self.create_new_user(auth, provider_params)
    user = User.create!(email: auth.info.email, password: Devise.friendly_token[0, 20])
    create_new_provider(user, provider_params)
    user
  end

  def self.user_exist?(auth, provider_params)
    user = User.find_by(email: auth.info.email)
    create_new_provider(user, provider_params) if user
    user
  end

  def self.create_new_provider(user, provider_params)
    user.providers.create(provider_params)
  end
end
