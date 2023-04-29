# frozen_string_literal: true
class PgCluster
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    ActiveRecord::Base.connection.execute('CLUSTER')
  end
end
