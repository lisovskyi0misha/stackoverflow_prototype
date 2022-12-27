FactoryBot.define do
  factory :questions_comment, class: 'Comment' do
    commentable_type { 'Question' }
    commentable_id { nil }
    body { 'Some body' }
    user
  end

  factory :answers_comment, class: 'Comment' do
    commentable_type { 'Answer' }
    commentable_id { nil }
    body { 'Some body' }
    user
  end
end
