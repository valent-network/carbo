# frozen_string_literal: true
class AdsWithFriendsQuery
  def call(user, ads_phone_number_ids)
    friends_relation_sql = UserRootFriendsForAdQuery.new.call(user.id, ads_phone_number_ids)
    phones = ads_phone_number_ids.join(', ')

    <<~SQL
      SELECT DISTINCT ON (ads.id) ads.id, friends.name AS friend_name, friends.idx AS friend_hands
      FROM (
        SELECT * FROM ads WHERE ads.phone_number_id IN (#{phones})
      ) AS ads
      JOIN (#{friends_relation_sql}) friends ON ads.phone_number_id = friends.phone_number_id
      ORDER BY ads.id, friends.idx
    SQL
  end
end
