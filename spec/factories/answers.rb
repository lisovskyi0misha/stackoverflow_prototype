FactoryBot.define do
  factory :answer do
    body { "Some body" }
  end

  factory :invalid_answer, class: 'Answer' do
    body { nil }
  end
end