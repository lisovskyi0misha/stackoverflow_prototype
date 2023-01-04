# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:

%w[1 2 3 4].each do |user|
  User.create(email: "test#{user}@email.com", password: '123456')
end

User.create(email: 'test5@email.com', password: '123456', admin: true)

%w[Question1 Question2 Quesiton3 Question4 Quesiton5].each_with do |quesiton|
  q = Question.create(title: quesiton, body: "Body for #{question}", user_id: User.all[quesiton.last])
  q.answers.create(body: 'Answer1 body', user_id: User.first.id)
  q.answers.create(body: 'Answer2 body', user_id: User.last.id)
  q.comments.create(body: 'Comment1', user_id: User.all[2])
end
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
