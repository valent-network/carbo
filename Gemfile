# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '3.2.0-preview2'

# Active Admin gems
gem 'activeadmin'
# TODO: https://github.com/formtastic/formtastic/issues/1325
# Ruby 3
gem 'formtastic', '~> 4.0'

gem 'arctic_admin'
gem 'devise'
gem 'sassc-rails'

# Main gems
gem 'pg'
gem 'puma'
gem 'rails', '~> 6'
gem 'sidekiq', '~> 7'
gem 'redisgraph'

gem 'rack-cors', require: 'rack/cors'
gem 'active_model_serializers'

# Secondary gems
gem 'dry-validation'
gem 'phonelib'
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'fog-aws'
gem 'rpush', '~> 5'
gem 'haml-rails'
gem 'kramdown'
gem 'aws-sdk-s3'
gem 'chartkick'
gem 'kaminari'
gem 'active_analytics'
gem 'lograge'
gem 'rack-attack'

# 3-rd party gems
gem 'turbosms'
gem 'airbrake'
gem 'newrelic_rpm'

gem 'bootsnap', '~> 1.9', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'spring'
end

group :test do
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-rails'
  gem 'rspec-retry'
end

group :test do
  gem 'simplecov', require: false
end

group :development do
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-shopify', require: false
  gem 'foreman', require: false
end

gem 'net-smtp'
gem 'net-pop'
gem 'net-imap'
