# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UserContact) do
  it ".ad_friends_for_user"
  it "belongs_to user"
  it "belongs_to phone_number"
  it "has_one friend"

  describe "Validates" do
    it "#phone_number"
    it "#name"
  end

  describe ".ad_friends_for_user" do
    let(:ad) { create(:ad, :active) }
    let(:user) { create(:user) }
    let!(:my_contacts) {}

    before do
      other_user = create(:user)
      create(:user_connection, user_id: user.id, friend_id: user.id, connection_id: user.id, hops_count: 0)
      create(:user_contact, user: user, phone_number: other_user.phone_number)
      create(:user_contact, user: user, phone_number: ad.phone_number)
      create(:user_contact, user: other_user, phone_number: ad.phone_number)
    end

    it "returns lowest hops_count" do
      friends = described_class.ad_friends_for_user(ad, user).to_a
      expect(friends.count).to eq(1)
      expect(friends.first.hops_count).to eq(1)
    end
  end
end
