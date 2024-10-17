require 'ffaker'
require 'openai'

puts "Seeding database..."

client = OpenAI::Client.new(
  access_token: ENV['OPENAI_API_KEY'],
  log_errors: true
)

def generate_question(client, topic)
  begin
    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          { role: "user", content: "Create a question related to #{topic} in a Q&A system." }
        ],
        temperature: 0.7,
        max_tokens: 100
      }
    )
    result = response.dig("choices", 0, "message", "content").strip
    puts "Generated question: #{result}"
    result
  rescue => e
    puts "Error generating question: #{e.message}"
    nil
  end
end

def generate_answer(client, question_title, length_type)
  max_tokens = case length_type
                 when :short
                   50
                 when :medium
                   100
                 when :detailed
                   200
               end

  begin
    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          { role: "user", content: "Provide a #{length_type} answer to the question: #{question_title}" }
        ],
        temperature: 0.7,
        max_tokens: max_tokens
      }
    )
    result = response.dig("choices", 0, "message", "content").strip
    puts "Generated answer (#{length_type}): #{result}" # Логирование результата
    result
  rescue => e
    puts "Error generating answer: #{e.message}"
    nil
  end
end

10.times do |n|
  User.create!(
    email: "user#{n + 1}@example.com",
    password: "password#{n + 1}",
    password_confirmation: "password#{n + 1}",
    name: FFaker::Name.name
  )
end

puts "10 users created with emails 'user1@example.com' - 'user10@example.com' and corresponding passwords 'password1' - 'password10'"

topics = ['Ruby on Rails', 'Elasticsearch', 'Stimulus.js', 'Active Storage']

GIST_URL = 'https://gist.github.com/vitaly-andr/83bdcd7a1a1282cb17085714494ded2a'
REAL_URLS = [
  'https://www.rubyonrails.org/',
  'https://www.github.com/',
  'https://www.stackoverflow.com/',
  'https://guides.rubyonrails.org/',
  'https://www.google.com/'
]

3.times do
  question_title = generate_question(client, topics.sample)
  next unless question_title # Пропускаем, если вопрос не был сгенерирован из-за ошибки

  question_body = generate_question(client, "Provide more details about the question: #{question_title}")
  sleep(2) # Минимальная задержка между запросами
  question = Question.create!(
    title: question_title,
    body: question_body,
    author: User.all.sample
  )

  question.links.create!([
                           { name: 'Gist Link', url: GIST_URL },
                           { name: FFaker::Lorem.word, url: REAL_URLS.sample }
                         ])

  [:short, :medium, :detailed].each do |length_type|
    answer_body = generate_answer(client, question.title, length_type)
    next unless answer_body # Пропускаем, если ответ не был сгенерирован

    answer = question.answers.create!(
      body: answer_body,
      author: User.all.sample
    )

    answer.links.create!([
                           { name: 'Gist Link', url: GIST_URL },
                           { name: FFaker::Lorem.word, url: REAL_URLS.sample }
                         ])
  end

  sleep(2)
end

puts "Seeding complete!"
