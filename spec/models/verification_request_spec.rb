# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(VerificationRequest) do
  it 'belongs_to phone_number'

  describe 'Validates' do
    it '#verification_code'
    it 'associated PhoneNumber'
  end
end
