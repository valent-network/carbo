# frozen_string_literal: true

class AdCarContract < Dry::Validation::Contract
  params do
    required(:price).value(:integer)
    required(:deleted).value(:bool)
    required(:phone).filled(:string)
    required(:details).hash do
      required(:maker).filled(:string)
      required(:model).filled(:string)
      required(:address).filled(:string)
      optional(:race).value(:integer)
      optional(:year).value(:integer)
      optional(:images_json_array_tmp).maybe(:string)
      optional(:engine_capacity).maybe(:integer)
      optional(:horse_powers).maybe(:integer)
      optional(:fuel).maybe(:string)
      optional(:gear).maybe(:string)
      optional(:wheels).maybe(:string)
      optional(:carcass).maybe(:string)
      optional(:region).maybe(:array)
      optional(:color).maybe(:string)
      optional(:description).maybe(:string)
      optional(:state_num).maybe(:string)
    end
  end

  rule(:price) do
    key.failure("must be greater than 0") if value.to_i <= 0
  end

  rule(:phone) do
    key.failure("is invalid") unless Phonelib.parse(value).valid?
  end

  rule(details: :images_json_array_tmp) do
    valid_json = begin
      JSON.parse(value)
    rescue
      false
    end
    key.failure("failed to JSON.parse") unless valid_json
    key.failure("is not JSON array") if valid_json && !JSON.parse(value).is_a?(Array)
  end
end
