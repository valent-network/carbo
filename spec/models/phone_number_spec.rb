# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(PhoneNumber, type: :model) do
  it '#to_s'
  it '#demo?'
  it '#demo'
  it '#demo='
  it '.by_full_number'
  it 'has_many ads'
  it 'has_many user_contacts'
  it 'has_one user'
  it 'has_one demo_phone_number'
  it 'valid OPERATORS'

  describe 'Validates' do
    it '#full_number'
  end
end
