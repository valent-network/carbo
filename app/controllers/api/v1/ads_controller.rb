# frozen_string_literal: true

module Api
  module V1
    class AdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.find(params[:id])
        AdVisitedJob.perform_later(current_user.id, ad.id)
        payload = AdSerializer.new(ad).as_json
        payload[:is_favorite] = current_user.ad_favorites.where(ad: ad).exists?

        render(json: payload)
      end
    end
  end
end
