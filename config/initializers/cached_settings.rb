# frozen_string_literal: true

Rails.configuration.after_initialize do
  KnownOption.refresh(concurrently: false) if Rails.env.test? && KnownOption.table_exists?
  CachedSettings.refresh if Category.table_exists?
rescue ActiveRecord::NoDatabaseError
  Rails.logger.warn("Skip loading cached settings since database connection was not established. Most likely, this run was initiated by `rails db:migrate` command")
end
