# frozen_string_literal: true
class PostgresCmdWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'refresh-matviews', retry: true, backtrace: false

  def perform(table_name)
    cmd = [
      'psql',
      '-h',
      ENV['POSTGRESQL_SERVICE_HOST'],
      '-U',
      ENV['POSTGRES_USER'],
      '-d',
      ENV['POSTGRES_DATABASE'],
      '-c',
      "\"REFRESH MATERIALIZED VIEW #{table_name}\""
    ].join(' ')

    %x(#{cmd})
  end
end
