# frozen_string_literal: true
class JsonValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid)
    super(options)
  end

  def validate_each(record, attribute, value)
    if value.is_a?(Hash) || value.is_a?(Array)
      value = value.to_json
    elsif value.is_a?(String)
      value = value.strip
    end
    JSON.parse(value)
  rescue JSON::ParserError, TypeError => exception
    record.errors.add(attribute, options[:message], exception_message: exception.message)
  end
end
