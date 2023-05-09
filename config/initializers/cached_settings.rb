# frozen_string_literal: true

Rails.configuration.after_initialize do
  CachedSettings.refresh if FilterableValue.table_exists?
end
