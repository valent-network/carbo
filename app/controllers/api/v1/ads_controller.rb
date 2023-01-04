# frozen_string_literal: true

module Api
  module V1
    class AdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.eager_load(:ads_source, :ad_description, :ad_extra, :ad_query, :ad_image_links_set, :ad_prices, :city, :region).find(params[:id])
        AdVisitedJob.perform_async(current_user.id, ad.id)
        CreateEvent.call(:visited_ad, user: current_user, data: { ad_id: ad.id })

        ads_with_friends_sql = AdsWithFriendsQuery.new.call(current_user, [ad.phone_number_id])
        ads_with_friends = Ad.find_by_sql(ads_with_friends_sql)

        ad.associate_friends_with(ads_with_friends)

        ad.my_ad! if current_user.phone_number_id == ad.phone_number_id

        payload = AdSerializer.new(ad).as_json
        payload[:is_favorite] = current_user.ad_favorites.where(ad: ad).exists?

        render(json: payload)
      end
    end
  end
end
