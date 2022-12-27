FactoryBot.define do
  factory :questions_comment, class: 'Comment' do
    association :commentable, factory: :just_question
    body { 'Some body' }
    association :user, factory: :user
  end

  factory :answers_comment, class: 'Comment' do
    association :commentable, factory: :just_answer
    body { 'Some body' }
    user
  end
end
