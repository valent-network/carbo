# frozen_string_literal: true
Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = ['ActionController']
  config.lograge.formatter = Lograge::Formatters::Logstash.new
end
