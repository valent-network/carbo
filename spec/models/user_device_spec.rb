# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(UserDevice) do
  it '#generate_access_token'
  it 'belongs_to user'

  describe 'Validates' do
    it '#access_token'
    it '#device_id'
    it '#os'
  end
end
