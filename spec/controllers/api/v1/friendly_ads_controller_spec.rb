# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::FriendlyAdsController) do
  let!(:user) { create(:user) }

  let(:friend) { create(:user) }
  let(:friend_2) { create(:user) }
  let(:friend_3) { create(:user) }
  let(:friend_of_friend) { create(:user) }
  let(:hand1_of_friend_of_friend) { create(:user) }

  let(:ad) { create(:ad, :active) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe '#show' do
    it 'hand1' do
      friend_contact = create(:user_contact, user: user, phone_number: ad.phone_number)
      expected_friends = [
        { 'id' => friend_contact.id, 'name' => friend_contact.name, 'idx' => 1, 'avatar' => nil, 'phone_number' => friend_contact.phone_number.to_s },
      ]
      get :show, params: { id: ad.id }
      expect(response).to(be_ok)
      expect(json_body).to(eq(expected_friends))
    end

    it 'hand2' do
      friend_contact = create(:user_contact, user: user, phone_number: friend.phone_number)
      create(:user_contact, user: friend, phone_number: ad.phone_number)
      expected_friends = [
        { 'id' => friend_contact.id, 'name' => friend_contact.name, 'idx' => 2, 'avatar' => nil, 'phone_number' => friend_contact.phone_number.to_s },
      ]
      get :show, params: { id: ad.id }
      expect(response).to(be_ok)
      expect(json_body).to(eq(expected_friends))
    end

    it 'hand3' do
      friend_contact = create(:user_contact, user: user, phone_number: friend.phone_number)
      create(:user_contact, user: friend, phone_number: friend_of_friend.phone_number)
      create(:user_contact, user: friend_of_friend, phone_number: ad.phone_number)
      expected_friends = [
        { 'id' => friend_contact.id, 'name' => friend_contact.name, 'idx' => 2, 'avatar' => nil, 'phone_number' => friend_contact.phone_number.to_s },
      ]
      get :show, params: { id: ad.id }
      expect(response).to(be_ok)
      expect(json_body).to(eq(expected_friends))
    end

    it 'hand1, hand2, hand3' do
      hand1_friend = create(:user_contact, user: user, phone_number: ad.phone_number)

      hand2_friend = create(:user_contact, user: user, phone_number: friend_2.phone_number)
      create(:user_contact, user: friend_2, phone_number: ad.phone_number)

      hand3_friend = create(:user_contact, user: user, phone_number: friend_3.phone_number)
      create(:user_contact, user: friend_3, phone_number: friend_of_friend.phone_number)
      create(:user_contact, user: friend_of_friend, phone_number: ad.phone_number)

      get :show, params: { id: ad.id }
      expect(response).to(be_ok)
      expect(json_body.detect { |x| x['id'] ==  hand1_friend.id }).to(eq({ 'id' => hand1_friend.id, 'name' => hand1_friend.name, 'idx' => 1, 'avatar' => nil, 'phone_number' => hand1_friend.phone_number.to_s }))
      expect(json_body.detect { |x| x['id'] ==  hand2_friend.id }).to(eq({ 'id' => hand2_friend.id, 'name' => hand2_friend.name, 'idx' => 2, 'avatar' => nil, 'phone_number' => hand2_friend.phone_number.to_s }))
      expect(json_body.detect { |x| x['id'] ==  hand3_friend.id }).to(eq({ 'id' => hand3_friend.id, 'name' => hand3_friend.name, 'idx' => 2, 'avatar' => nil, 'phone_number' => hand3_friend.phone_number.to_s }))
    end
  end
end
