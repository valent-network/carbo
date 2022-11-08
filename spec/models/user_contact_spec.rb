# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(UserContact) do
  it '.ad_friends_for_user'
  it 'belongs_to user'
  it 'belongs_to phone_number'
  it 'has_one friend'

  describe 'Validates' do
    it '#phone_number'
    it '#name'
  end
end
