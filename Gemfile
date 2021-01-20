# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Active Admin gems
gem 'activeadmin'
# TODO: https://github.com/formtastic/formtastic/issues/1325
# Ruby 3
gem 'formtastic', '4.0.0.rc1'

gem 'arctic_admin'
gem 'devise'
gem 'sassc-rails'

# Main gems
gem 'pg'
gem 'puma'
gem 'rails', '~> 6'
gem 'sidekiq'
gem 'clockwork'

gem 'rack-cors', require: 'rack/cors'
gem 'active_model_serializers'

# Secondary gems
gem 'paper_trail'
gem 'dry-validation'
gem 'phonelib'
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'fog-aws'
gem 'rpush'
gem 'haml-rails'
gem 'kramdown'
gem 'aws-sdk-s3'
gem 'chartkick'

# 3-rd party gems
gem 'turbosms'
gem 'airbrake'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-rails'
  gem 'dotenv-rails'
  gem 'spring'
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
end
