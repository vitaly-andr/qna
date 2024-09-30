# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'ffaker'

puts "Seeding database..."

GIST_URL = 'https://gist.github.com/vitaly-andr/83bdcd7a1a1282cb17085714494ded2a'

REAL_URLS = [
  'https://www.rubyonrails.org/',
  'https://www.github.com/',
  'https://www.stackoverflow.com/',
  'https://guides.rubyonrails.org/',
  'https://www.google.com/'
]

10.times do |n|
  User.create!(
    email: "user#{n + 1}@example.com",
    password: "password#{n + 1}",
    password_confirmation: "password#{n + 1}",
    name: FFaker::Name.name
  )
end

puts "10 users created with emails 'user1@example.com' - 'user10@example.com' and corresponding passwords 'password1' - 'password10'"

users = User.all

10.times do
  question = Question.create!(
    title: FFaker::Lorem.sentence,
    body: FFaker::Lorem.paragraph,
    author: users.sample
  )

  rand(3..5).times do
    Answer.create!(
      body: FFaker::Lorem.sentence,
      question: question,
      author: users.sample
    )
  end

  question.links.create!(
    [
      { name: 'Gist Link', url: GIST_URL },
      { name: FFaker::Lorem.word, url: REAL_URLS.sample }
    ]
  )
end

puts "Seeding complete!"
