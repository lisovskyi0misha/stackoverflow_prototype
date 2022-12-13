FactoryBot.define do
  sequence :body do |n|
    "Answer #{n}"
  end

  factory :answer do
    body
    question_id { nil }
    user_id { nil }
  end

  factory :invalid_answer, class: 'Answer' do
    body { nil }
    question_id { nil }
    user_id { nil }
  end

  factory :just_answer, class: 'Answer' do
    body
    association :question, factory: :just_question
    user
  end
end
