# frozen_string_literal: true

module Api
  module V1
    class AdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.where(id: params[:id]).eager_load(:ad_description, :city, :ad_image_links_set, :ad_prices, ad_options: [:ad_option_type, :ad_option_value]).first
        AdVisitedJob.perform_async(current_user.id, ad.id)
        CreateEvent.call(:visited_ad, user: current_user, data: { ad_id: ad.id })

        ads_with_friends_sql = AdsWithFriendsQuery.new.call(current_user, [ad.phone_number_id])
        ads_with_friends = Ad.find_by_sql(ads_with_friends_sql)

        ad.associate_friends_with(ads_with_friends)

        payload = AdSerializer.new(ad).as_json
        payload[:is_favorite] = current_user.ad_favorites.where(ad: ad).exists?

        render(json: payload)
      end
    end
  end
end
