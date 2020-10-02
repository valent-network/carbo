# frozen_string_literal: true

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['DO_SPACE_KEY'],
    aws_secret_access_key: ENV['DO_SPACE_SECRET'],
    region: ENV['DO_SPACE_REGION'],
    host: "#{ENV['DO_SPACE_REGION']}.digitaloceanspaces.com",
    endpoint: "https://#{ENV['DO_SPACE_REGION']}.digitaloceanspaces.com",
  }
  config.fog_directory = ENV['DO_SPACE_NAME']
  config.fog_public = true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
  config.storage = Rails.env.test? ? :file : :fog
end
