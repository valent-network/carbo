# frozen_string_literal: true

module Api
  module V2
    class VisitedAdsController < ApplicationController
      before_action :require_auth

      def index
        ads_ids = Ad.order_by_visit_for(current_user).limit(20).offset(params[:offset]).ids

        ads = Ad.eager_load(:category, :ad_images, :ad_favorites, :ad_description, :ad_extra, :ad_query, :ad_image_links_set, :city, :region).where(id: ads_ids)
        ads = ads.to_a.sort_by { |ad| ads_ids.index(ad.id) }

        if ads.present?
          ads_with_friends_sql = AdsWithFriendsQuery.new.call(current_user, ads.pluck(:phone_number_id))
          ads_with_friends = Ad.find_by_sql(ads_with_friends_sql)

          ads.each { |ad| current_user.phone_number_id == ad.phone_number_id ? ad.my_ad! : ad.associate_friends_with(ads_with_friends) }
        end

        render(json: ads, each_serializer: AdsListSerializer, current_user: current_user)
      end
    end
  end
end
