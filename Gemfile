# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

# Main gems
gem "pg"
gem "puma"
gem "rails", "~> 7"
gem "sidekiq", "~> 7"
gem "redisgraph"
gem "rpush", "~> 7"
gem "clockwork"

# Secondary gems
gem "dry-validation"
gem "active_model_serializers"
gem "phonelib"
gem "carrierwave"
gem "carrierwave-base64"
gem "fog-aws"

# 3-rd party gems
gem "turbosms"
gem "aws-sdk-s3"
gem "sentry-ruby"
gem "sentry-rails"
gem "sentry-sidekiq"

# Other
gem "bootsnap", "~> 1.9", require: false
gem "rack-cors", require: "rack/cors"
gem "rack-attack"
gem "lograge"
gem "logstash-event"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "spring"
  gem "steep", require: false
  gem "rbs", require: false
  gem "rbs_rails", require: false
end

group :test do
  gem "factory_bot_rails"
  gem "ffaker"
  gem "rspec-rails"
  gem "rspec-retry"
end

group :test do
  gem "simplecov", require: false
end

group :development do
  gem "listen"
  gem "standardrb", require: false
  gem "foreman", require: false
  gem "derailed_benchmarks"
  gem "stackprof"
end

### Remove candidates ###

# Active Admin gems
gem "activeadmin"
gem "arctic_admin"
gem "devise"
gem "sassc-rails"
gem "formtastic", "~> 4.0" # TODO: Ruby 3: https://github.com/formtastic/formtastic/issues/1325
gem "haml-rails"
gem "chartkick"
gem "kaminari"

###

gem "mail", "~> 2.7.1" # TODO: https://github.com/mikel/mail/issues/1489
