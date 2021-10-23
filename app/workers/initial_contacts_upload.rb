# frozen_string_literal: true
class InitialContactsUpload
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: true, backtrace: false

  def perform(user_id, init_time)
    init_time = Time.at(init_time)
    ads_last_refreshed_at = REDIS.get('server.effective_ads.last_refreshed_at')

    if ads_last_refreshed_at.present? && Time.zone.parse(ads_last_refreshed_at).after?(init_time)
      user = User.find(user_id)
      ApplicationCable::UserChannel.broadcast_to(user, type: 'contacts')
    else
      self.class.perform_in(5.seconds, user_id, init_time.to_i)
    end
  end
end
