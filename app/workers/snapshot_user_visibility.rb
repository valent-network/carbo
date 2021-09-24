# frozen_string_literal: true

class SnapshotUserVisibility
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: true, backtrace: false

  def perform
    User.find_each do |user|
      CreateEvent.call(:snapshot_user_visibility, user: user, data: user.current_visibility)
    end
  end
end
