class Provider < ApplicationRecord
  validates_presence_of :uid, :provider_name
  belongs_to :user
end