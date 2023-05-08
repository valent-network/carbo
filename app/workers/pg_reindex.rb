# frozen_string_literal: true

class PgReindex
  include Sidekiq::Worker

  sidekiq_options queue: "system", retry: true, backtrace: false

  def perform
    ActiveRecord::Base.connection.execute("REINDEX DATABASE #{Rails.configuration.database_configuration[Rails.env]["database"]}")
  end
end
