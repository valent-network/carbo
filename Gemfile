# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Active Admin gems
gem 'activeadmin'
gem 'arctic_admin'
gem 'devise'
gem 'sassc-rails', '~> 2.1', '>= 2.1.1'

# Main gems
gem 'pg'
gem 'puma', '~> 4'
gem 'rails', '~> 6'
gem 'sidekiq'
gem 'clockwork'

gem 'rack-cors', require: 'rack/cors'
gem 'active_model_serializers'

# Secondary gems
gem 'paper_trail'
gem 'dry-validation'
gem 'phonelib'
gem 'carrierwave', '~> 2.0'
gem 'carrierwave-base64'
gem 'fog-aws'
gem 'rpush'

# 3-rd party gems
gem 'turbosms'
gem 'airbrake'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-rails', '~> 4'
  gem 'dotenv-rails'
  gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '0.81.0', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-shopify', require: false
end
