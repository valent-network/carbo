# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(User) do
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
      create(:user_connection, user: user, friend: user, connection: user)
      create_list(:ad, 3, phone_number: user_contact.phone_number, deleted: false)
      expect(user.reload.visible_ads_count).to(eq(3))
    end
  end

  describe '#visible_friends_count' do
    it 'shows count users available for the user through friends recursively' do
      create_list(:user_contact, 8, user: user)
      known_phone_number = user.user_contacts.first.phone_number
      friend = create(:user, phone_number: known_phone_number)
      create(:user_connection, user: user, friend: user, connection: user)
      create(:user_connection, user: user, friend: friend, connection: friend)
      create_list(:user_contact, 5, user: friend)

      expect(user.reload.visible_friends_count).to(eq(13))
    end
  end

  describe '#update_connections!' do
    it 'does not save connections to myself and does not delete existing connections' do
      allow(USER_FRIENDS_GRAPH).to(receive_message_chain(:get_friends_connections, :resultset).and_return([[]]))
      create(:user_connection, user: user, friend: user, connection: user)

      expect { user.update_connections! }.not_to(change { user.reload.user_connections.count })
      expect(user.user_connections.find_by(user: user, friend: user)).to(be_persisted)
    end

    it 'adds self-self connection in any case (but only once)' do
      allow(USER_FRIENDS_GRAPH).to(receive_message_chain(:get_friends_connections, :resultset).and_return([[]]))

      expect { user.update_connections! }.to(change { user.user_connections.where(friend: user, connection: user).count }.from(0).to(1))
    end

    it 'upserts connections' do
      friend = create(:user)
      allow(USER_FRIENDS_GRAPH).to(receive_message_chain(:get_friends_connections, :resultset).and_return([[friend.id, friend.id, 1]]))
      create(:user_connection, user: user, friend: friend, connection: friend, hops_count: nil)

      expect { user.update_connections! }.to(change { user.user_connections.find_by(friend: friend, connection: friend).hops_count }.from(nil).to(1))
    end
  end
end
