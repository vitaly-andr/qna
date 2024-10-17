source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.1"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

gem "slim-rails"

gem 'aws-sdk-s3', '~> 1.0'

gem 'image_processing'
gem 'requestjs-rails'
gem 'jsbundling-rails'
gem 'cssbundling-rails'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'rest-client'
gem 'omniauth-google-oauth2'
gem 'omniauth-oauth2'
gem 'omniauth-vkontakte'
gem 'pundit'
gem 'active_model_serializers', '~> 0.10.0'
gem 'doorkeeper'
gem 'oj'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'elasticsearch', '~> 8.0'
gem 'searchkick'
gem 'ruby-openai'
gem 'dotenv-rails', groups: [:development, :test, :production]
gem 'mini_racer'



gem "devise"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  gem "rspec-rails"
  gem "factory_bot_rails"
  gem 'ffaker'
  gem "simplecov", require: false
  gem 'webmock'
  gem 'letter_opener'
  gem 'capybara-email'


  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  # Generate a diagram of all the models in the app by running:
  # bundle exec erd
  gem "rails-erd"

  gem 'capistrano', '~> 3.17', require: false
  gem 'capistrano-rails', '~> 1.6', require: false
  gem 'capistrano3-puma', '>= 6.0.0.beta.1', '< 6.1', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-bundler', '~> 2.1', require: false
  gem 'capistrano-sidekiq', '~> 2.0', require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem 'cuprite'
  gem "selenium-webdriver"
  gem 'shoulda-matchers', '~> 6.0'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'pundit-matchers'
  gem 'database_cleaner-active_record'


end
