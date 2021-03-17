# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(User, type: :model) do
  let(:user) { create(:user) }
  let(:sample_image_base64) { Base64.strict_encode64(File.read(Rails.root.join('spec/support/sample.png'))) }
  describe '#avatar' do
    it 'successfully consumes base64 image' do
      expect { user.update(avatar: "data:image/png;base64,#{sample_image_base64}") }.to(change { user.reload.avatar.size }.from(0).to(5138))
    end
  end

  describe '#contacts_count' do
    it 'shows count of user.user_contacts' do
      create_list(:user_contact, 8, user: user)
      expect(user.contacts_count).to(eq(8))
    end
  end

  describe '#visible_ads_count' do
    it 'shows count ads available for the user through friends recursively' do
      user_contact = create(:user_contact, user: user)
      create_list(:ad, 3, phone_number: user_contact.phone_number, deleted: false)
      EffectiveUserContact.refresh
      EffectiveAd.refresh
      expect(user.reload.visible_ads_count).to(eq(3))
    end
  end

  describe '#visible_friends_count' do
    it 'shows count users available for the user through friends recursively' do
      create_list(:user_contact, 8, user: user)
      friend = create(:user, phone_number: user.user_contacts.first.phone_number)
      create_list(:user_contact, 5, user: friend)
      EffectiveUserContact.refresh
      expect(user.reload.visible_friends_count).to(eq(13))
    end
  end
end
