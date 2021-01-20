# frozen_string_literal: true
class PhoneValidator < ActiveModel::EachValidator
  # TODO: https://github.com/daddyz/phonelib/issues/209
  # Validation method
  def validate_each(record, attribute, value)
    return if options[:allow_blank] && value.blank?

    @phone = parse(value, specified_country(record))
    valid = phone_valid? && valid_types? && valid_country? && valid_extensions?

    record.errors.add(attribute, message, **options) unless valid
  end
end
