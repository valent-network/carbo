# frozen_string_literal: true

require 'simplecov'
SimpleCov.start('rails') do
  add_filter '/app/admin/'
  add_filter '/vendor/'
  add_filter '/lib/api_tasters/'
  add_filter '/app/services/push_service.rb'
end

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'rspec/retry'
# require 'action_cable/testing/rspec'
# Add additional requires below this line. Rails is not loaded until this point!

I18n.default_locale = :en

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

module JSONHelpers
  def json_body
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)
  config.include(JSONHelpers)

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.run_all_when_everything_filtered = true
  config.filter_run(:focus) unless ENV['CI']

  config.after do
    if Rails.env.test?
      FileUtils.rm_rf(Dir[Rails.root.join('public/uploads')])
    end
  end

  retry_limit = ENV['RSPEC_RETRY_LIMIT'].to_i
  if retry_limit > 0
    config.around do |ex|
      ex.run_with_retry(retry: retry_limit)
    end
  end

  config.before(:all) do
    {
      1 => 'fuel',
      2 => 'gear',
      3 => 'race',
      4 => 'year',
      5 => 'color',
      6 => 'maker',
      7 => 'model',
      8 => 'region',
      9 => 'wheels',
      10 => 'address',
      11 => 'carcass',
      12 => 'customs_clear',
      13 => 'city',
      14 => 'state_num',
      15 => 'seller_name',
      16 => 'engine_capacity',
      17 => 'horse_powers',
      18 => 'fuel_string',
      19 => 'new_car',
    }.each do |key, value|
      AdOptionType.create(id: key, name: value)
    end
    KnownAd.refresh(concurrently: false)
    EffectiveAd.refresh(concurrently: false)
  end
end
