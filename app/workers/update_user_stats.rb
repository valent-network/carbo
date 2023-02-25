# frozen_string_literal: true
class UpdateUserStats
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    connection = ActiveRecord::Base.connection

    queries = [
      UpdateUserStatTopRegions.new.call,
      UpdateUserStatAdoptionPercentage.new.call,
      UpdateUserStatPotentialReach.new.call,
      UpdateUserStatActivityPercentage.new.call,
      <<~SQL
        UPDATE users
        SET stats['updated_at'] = to_jsonb(NOW())
      SQL
    ]

    User.transaction(isolation: :read_committed) do
      queries.each { |q| connection.execute(q) }
    end
  end
end
