FactoryBot.define do
  factory :vote do
    user_id { nil }
    votable_id { nil }
    votable_type { nil }
    status { 0 }
  end
end
