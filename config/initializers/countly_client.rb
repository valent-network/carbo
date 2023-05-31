# frozen_string_literal: true

Rails.configuration.after_initialize do
  COUNTLY_CLIENT = CountlyClient.new(ENV["COUNTLY_API_KEY"]) # standard:disable Lint/ConstantDefinitionInBlock
end
