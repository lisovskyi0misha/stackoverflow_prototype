FactoryBot.define do
  factory :vote do
    user_id { nil }
    answer_id { nil }
    status { 0 }
  end
end
