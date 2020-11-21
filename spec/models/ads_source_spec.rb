# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdsSource, type: :model) do
  it 'has_many ads'
  describe 'Validates' do
    it '#title'
    it '#api_token'
  end
end
