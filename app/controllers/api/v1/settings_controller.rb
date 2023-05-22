# frozen_string_literal: true

module Api
  module V1
    class SettingsController < ApplicationController
      before_action :require_auth, :require_admin, only: [:update]
      def show
        settings = CachedSettings.new

        payload = {
          cities: settings.cities,
          categories: settings.categories.sort_by { |c| c["position"] }
        }

        render(json: payload)
      end

      def update
        # TODO: Temp implementation
        ActiveRecord::Base.transaction do
          params[:categories].each do |c|
            Category.where(id: c[:id]).update_all(position: c[:position])
            c[:ad_option_types].each do |o|
              AdOptionType.where(id: o[:id]).update_all(position: o[:position])
              o[:values].each do |v|
                FilterableValuesGroup.where(id: v[:id]).update_all(position: v[:position])
              end
            end
          end
        end
        head 200
      end
    end
  end
end
