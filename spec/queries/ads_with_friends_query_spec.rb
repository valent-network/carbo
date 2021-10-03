# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdsWithFriendsQuery) do
  it 'fails when no ads phone numbers provided'
  it 'calls for UserRootFriendsForAdQuery'
  it 'filters out self phone number from my contacts'

  describe 'Returning records attributes' do
    it '#id'
    it '#friend_name'
    it '#friend_id'
  end
end
