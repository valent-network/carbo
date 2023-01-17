# frozen_string_literal: true
module SettingsUpdateable
  extend ActiveSupport::Concern

  included do
    after_save :update_settings
  end

  private

  def update_settings
    CachedSettings.refresh
  end
end
