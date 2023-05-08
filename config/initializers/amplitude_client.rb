# frozen_string_literal: true

Rails.configuration.after_initialize do
  AMPLITUDE_CLIENT = AmplitudeClient.new(ENV["AMPLITUDE_API_KEY"]) # standard:disable Lint/ConstantDefinitionInBlock
end
