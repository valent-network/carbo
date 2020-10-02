# frozen_string_literal: true

module Api
  module V1
    class VisitedAdsController < ApplicationController
      before_action :require_auth

      def index
        ads = Ad.joins(:ad_visits).where(ad_visits: { user_id: current_user.id }).order('ads.created_at DESC').limit(20).offset(params[:offset])

        render(json: ads, each_serializer: Api::V1::AdsListSerializer)
      end
    end
  end
end
