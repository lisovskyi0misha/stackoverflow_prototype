FactoryBot.define do
  sequence :title do |n|
    "Question title #{n}"
  end

  factory :question do
    title { 'Some title' }
    body { 'Some body' }
    user_id { nil }
  end

  factory :invalid_question, class: 'Question' do
    title { nil }
    body { nil }
  end

  factory :several_questions, class: 'Question' do
    title
    body { 'Some body' }
    user_id { nil }
  end

  factory :just_question, class: 'Question' do
    title
    body { 'Some body' }
    user
    files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/test_file.txt", 'text/plain')] }
  end
end
