# frozen_string_literal: true
module Api
  module V1
    class SettingsController < ApplicationController
      def show
        settings = CachedSettings.new

        payload = {
          cities: settings.cities,
          categories: settings.categories,
        }

        render(json: payload)
      end
    end
  end
end
