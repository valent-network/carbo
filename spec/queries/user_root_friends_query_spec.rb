# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(UserRootFriendsForAdQuery) do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:friend_of_friend) { create(:user) }
  let!(:hand1_of_friend_of_friend) { create(:user) }
  let!(:hand1) { create(:user_contact, user: user, phone_number: friend.phone_number, name: 'Alice') }
  let!(:hand2) { create(:user_contact, user: friend, phone_number: friend_of_friend.phone_number) }
  let!(:hand3) { create(:user_contact, user: friend_of_friend, phone_number: hand1_of_friend_of_friend.phone_number) }

  it 'hand1' do
    query = subject.call(user.id, hand1.phone_number_id)
    result = ActiveRecord::Base.connection.select_all(query).to_a
    expect(result.count).to(eq(1))
    expect(result.first['id']).to(eq(hand1.id))
    expect(result.first['name']).to(eq(hand1.name))
    expect(result.first['phone_number_id']).to(eq(hand1.phone_number_id))
    expect(result.first['idx']).to(eq(1))
  end

  it 'hand2' do
    query = subject.call(user.id, hand2.phone_number_id)
    result = ActiveRecord::Base.connection.select_all(query).to_a
    expect(result.count).to(eq(1))
    expect(result.first['id']).to(eq(hand1.id))
    expect(result.first['name']).to(eq(hand1.name))
    expect(result.first['phone_number_id']).to(eq(hand2.phone_number_id))
    expect(result.first['idx']).to(eq(2))
  end

  it 'hand3' do
    query = subject.call(user.id, hand3.phone_number_id)
    result = ActiveRecord::Base.connection.select_all(query).to_a
    expect(result.count).to(eq(1))
    expect(result.first['id']).to(eq(hand1.id))
    expect(result.first['name']).to(eq(hand1.name))
    expect(result.first['phone_number_id']).to(eq(hand3.phone_number_id))
    expect(result.first['idx']).to(eq(3))
  end

  it 'shows hand3 if connects throuhg both hand2 and directly' do
    ad_author = create(:user)
    max = create(:user)
    dima = create(:user)
    vlad = create(:user)
    sergey = create(:user)
    denis = create(:user)

    max.user_contacts.create([{ name: 'Denis', phone_number: denis.phone_number }, { name: 'Dima', phone_number: dima.phone_number }])
    denis.user_contacts.create([{ name: 'Author', phone_number: ad_author.phone_number }])
    sergey.user_contacts.create([{ name: 'Max', phone_number: max.phone_number }, { name: 'Vlad', phone_number: vlad.phone_number }, { name: 'Dima', phone_number: dima.phone_number }])
    dima.user_contacts.create({ name: 'Author', phone_number: ad_author.phone_number })
    vlad.user_contacts.create([{ name: 'Max', phone_number: max.phone_number }, { name: 'Dima', phone_number: dima.phone_number }, { name: 'Me', phone_number: user.phone_number }, { name: 'Author', phone_number: ad_author.phone_number }])
    user.user_contacts.create([{ name: 'Max', phone_number: max.phone_number }, { name: 'Dima', phone_number: dima.phone_number }, { name: 'Vlad', phone_number: vlad.phone_number }, { name: 'Sergey', phone_number: sergey.phone_number }])

    query = subject.call(user.id, ad_author.phone_number_id)
    result = ActiveRecord::Base.connection.select_all(query).to_a

    expected_names = result.map { |row| row['name'] }
    expect(expected_names).to(match_array(%w[Vlad Max Dima]))
  end
end
