# frozen_string_literal: true

module Api
  module V1
    class VisitedAdsController < ApplicationController
      before_action :require_auth

      def index
        ads = Ad.eager_load(:ad_description, :ad_extra, :ad_query, :ad_image_links_set, :city, :region).joins(:ad_visits).where(ad_visits: { user_id: current_user.id }).order('ads.created_at DESC').limit(20).offset(params[:offset])

        if ads.present?
          ads_with_friends_sql = AdsWithFriendsQuery.new.call(current_user, ads.pluck(:phone_number_id))
          ads_with_friends = Ad.find_by_sql(ads_with_friends_sql)

          ads.each { |ad| ad.associate_friends_with(ads_with_friends) }
        end

        render(json: ads, each_serializer: Api::V1::AdsListSerializer)
      end
    end
  end
end
