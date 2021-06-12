# frozen_string_literal: true
class Event < ApplicationRecord
  EVENT_TYPES = %w[sign_up sign_out deleted_contacts uploaded_contatcts
                   get_feed set_referrer invited_user visited_ad favorited_ad unfavorited_ad]
  belongs_to :user
  validates :name, presence: true
  validates :name, inclusion: { in: EVENT_TYPES }
  validates :data, exclusion: { in: [nil] }
end
