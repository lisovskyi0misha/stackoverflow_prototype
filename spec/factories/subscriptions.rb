FactoryBot.define do
  factory :subscription do
    association :question
    association :subscribed_user, factory: :user
  end
end
