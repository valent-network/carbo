# frozen_string_literal: true
module Api
  module V1
    class MyAdsController < ApplicationController
      before_action :require_auth

      def index
        ads = current_user.ads.includes(:ad_image_links_set, :ad_query, :ad_description, :city, :region, :ad_favorites).order(created_at: :desc).limit(20).offset(params[:offset])
        ads.each(&:my_ad!)
        payload = ActiveModelSerializers::SerializableResource.new(ads, each_serializer: Api::V1::AdsListSerializer, current_user: current_user).as_json

        render(json: payload)
      end
    end
  end
end
