# frozen_string_literal: true
class PgAnalyze
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    ActiveRecord::Base.connection.execute('ANALYZE')
  end
end
