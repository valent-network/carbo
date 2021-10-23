# frozen_string_literal: true

class SnapshotUserVisibility
  BATCH_SIZE = 100

  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    users = User.joins("LEFT JOIN events ON events.user_id = users.id AND events.name = 'snapshot_user_visibility' AND events.created_at > (NOW() - INTERVAL '1 day')")
      .where('events.id IS NULL')
      .limit(BATCH_SIZE)

    users.each do |user|
      CreateEvent.call(:snapshot_user_visibility, user: user, data: user.current_visibility)
    end
  end
end
