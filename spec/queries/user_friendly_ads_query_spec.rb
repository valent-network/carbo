# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(UserFriendlyAdsQuery) do
  let!(:some_phone_number) { create(:phone_number) }
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:friend_of_friend) { create(:user) }
  let!(:hand1_of_friend_of_friend) { create(:user) }

  let!(:ad_hand1_no_user) { create(:ad, :active, phone: some_phone_number.full_number) }
  let!(:ad_hand1) { create(:ad, :active, phone: friend.phone_number) }
  let!(:ad_hand2) { create(:ad, :active, phone: friend_of_friend.phone_number) }
  let!(:ad_hand3) { create(:ad, :active, phone: hand1_of_friend_of_friend.phone_number) }
  let!(:ad_unknown) { create(:ad, :active) }

  before do
    create(:user_contact, user: user, phone_number: some_phone_number)
    create(:user_contact, user: user, phone_number: friend.phone_number)
    create(:user_contact, user: friend, phone_number: friend_of_friend.phone_number)
    create(:user_contact, user: friend_of_friend, phone_number: hand1_of_friend_of_friend.phone_number)

    create(:user_connection, user: user, friend: friend, connection: friend, hops_count: 1)
    create(:user_connection, user: user, friend: friend, connection: friend_of_friend, hops_count: 2)
    create(:user_connection, user: user, friend: user, connection: user, hops_count: 1)
  end

  context 'With successful result' do
    subject { described_class.new.call(user: user) }

    it 'matches expected friendly ads' do
      expected_ads = [
        ad_hand1, ad_hand2, ad_hand3, ad_hand1_no_user
      ]
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      expect(subject).to(match_array(expected_ads))
    end

    it 'returns Ad relation' do
      expect(subject).to(be_a(ActiveRecord::Relation))
    end

    it 'does not show deleted ads' do
      ad_hand2.update(deleted: true)
      expected_ads = [
        ad_hand1, ad_hand3, ad_hand1_no_user
      ]
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      expect(subject).to(match_array(expected_ads))
    end

    it 'applies offset' do
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      expect(described_class.new.call(user: user, offset: 2).count).to(eq(2))
    end

    it 'orders by date' do
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      # expect(subject.last.id).to(eq(ad_hand1_no_user.id))
      expect(subject.first.id).to(eq(ad_hand3.id))
      expect(subject.first.created_at).to(be > subject.last.created_at)
    end

    it 'limits result' do
      UserFriendlyAdsQuery::LIMIT.times do
        create(:user_contact, user: user, phone_number: create(:ad, :active).phone_number)
      end
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      expect(described_class.new.call(user: user).count).to(eq(UserFriendlyAdsQuery::LIMIT))
    end

    it 'filters by maker and model if not match user contacts' do
      ad = create(:ad, :active, phone: friend.phone_number)
      ad.details = ad.details.merge('maker' => 'BMW', 'model' => 'X6')
      ad.save
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      expect(described_class.new.call(user: user, filters: { query: 'BMW X6' })).to(match_array([ad]))
      expect(described_class.new.call(user: user, filters: { query: 'BMW' })).to(match_array([ad]))
      expect(described_class.new.call(user: user, filters: { query: 'X6' })).to(match_array([ad]))
    end

    # TODO: May occasionally fail
    it 'filters by user contacts if match hand1' do
      new_friend = create(:user)
      create(:user_contact, user: user, phone_number: new_friend.phone_number, name: 'John')
      ad = create(:ad, :active, phone: new_friend.phone_number)
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      expected_ads = described_class.new.call(user: user, filters: { query: 'John' })

      expect(expected_ads).to(match_array([ad]))
    end

    it 'filters by user contacts if match hand2' do
      user.user_contacts.find_by(phone_number: friend.phone_number).update(name: 'John')
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      expected_ads = described_class.new.call(user: user, filters: { query: 'John' })
      expect(expected_ads).to(match_array([ad_hand1, ad_hand2]))
    end

    it 'filters by contacts_mode' do
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      expected_ads = [ad_hand1_no_user, ad_hand1]
      expect(described_class.new.call(user: user, filters: { contacts_mode: 'directFriends' })).to(match_array(expected_ads))
    end
  end
end
