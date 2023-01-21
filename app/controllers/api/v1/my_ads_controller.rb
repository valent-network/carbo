# frozen_string_literal: true
module Api
  module V1
    class MyAdsController < ApplicationController
      before_action :require_auth

      def index
        ads = current_user.ads.includes(:category, :ad_images, :ad_favorites, :ad_image_links_set, :ad_query, :ad_description, :city, :region).order(created_at: :desc).limit(20).offset(params[:offset])
        ads.each(&:my_ad!)

        render(json: ads, each_serializer: Api::V1::AdsListSerializer, current_user: current_user)
      end
    end
  end
end
