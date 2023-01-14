# frozen_string_literal: true
class Event < ApplicationRecord
  # rubocop:disable Layout/MultilineArrayLineBreaks
  EVENT_TYPES = %w[
    sign_up sign_in sign_out deleted_contacts uploaded_contatcts
    get_feed set_referrer invited_user visited_ad favorited_ad
    unfavorited_ad finished_session snapshot_user_visibility
  ]
  # rubocop:enable Layout/MultilineArrayLineBreaks
  belongs_to :user
  validates :name, presence: true
  validates :name, inclusion: { in: EVENT_TYPES }
  validates :data, exclusion: { in: [nil] }

  def self.stats_for(event_type_name)
    where(name: event_type_name).where('created_at > ?', 6.month.ago).order('date(created_at)').group('date(created_at)').count
  end
end
