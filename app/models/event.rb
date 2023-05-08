# frozen_string_literal: true

class Event < ApplicationRecord
  EVENT_TYPES = %w[
    sign_up sign_in sign_out deleted_contacts uploaded_contatcts
    get_feed set_referrer invited_user visited_ad favorited_ad unfavorited_ad
    chat_room_user_added chat_room_initiated message_posted chat_room_left
  ]
  belongs_to :user
  validates :name, presence: true
  validates :name, inclusion: {in: EVENT_TYPES}
  validates :data, exclusion: {in: [nil]}

  scope :ad_visits_ordered, -> { where(name: "visited_ad").order("created_at DESC").select("(events.data->>'ad_id')::integer AS id, created_at") }
  scope :ad_favorites_ordered, -> { where(name: "favorited_ad").order("created_at DESC").select("(events.data->>'ad_id')::integer AS id, created_at") }

  def self.stats_for(event_type_name)
    where(name: event_type_name).where("created_at > ?", 6.month.ago).order("date(created_at)").group("date(created_at)").count
  end
end
