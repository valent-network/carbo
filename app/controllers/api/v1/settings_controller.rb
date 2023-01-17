# frozen_string_literal: true
module Api
  module V1
    class SettingsController < ApplicationController
      def show
        settings = CachedSettings.new

        payload = {
          filters: { hops_count: t('hops_count').map.with_index.to_a.map { |h| { name: h.first, id: h.last } } },
          cities: settings.cities,
          categories: settings.categories,
        }

        render(json: payload)
      end
    end
  end
end
