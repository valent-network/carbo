# frozen_string_literal: true

module Api
  module V1
    class FavoriteAdsController < ApplicationController
      before_action :require_auth

      def index
        ads = Ad.eager_load(:ad_description, :ad_image_links_set, city: [:region], ad_options: [:ad_option_type, :ad_option_value]).joins(:ad_favorites).where(ad_favorites: { user_id: current_user.id }).order('ads.created_at DESC').limit(20).offset(params[:offset])

        if ads.present?
          ads_with_friends_sql = AdsWithFriendsQuery.new.call(current_user, ads.pluck(:phone_number_id))
          ads_with_friends = Ad.find_by_sql(ads_with_friends_sql)

          ads.each { |ad| ad.associate_friends_with(ads_with_friends) }
        end

        render(json: ads, each_serializer: Api::V1::AdsListSerializer)
      end

      def create
        ad_favorite = current_user.ad_favorites.where(ad_id: params[:id]).first_or_initialize
        if ad_favorite.save
          CreateEvent.call(:favorited_ad, user: current_user, data: { ad_id: params[:id] })
          render(json: { message: :ok })
        else
          render(json: { message: :error, errors: ad_favorite.errors.to_a }, status: 422)
        end
      end

      def destroy
        ad_favorite = current_user.ad_favorites.where(ad_id: params[:id]).first

        return render(json: { message: :error, errors: ['Ad must exist'] }, status: 422) unless ad_favorite

        ad_favorite.destroy
        CreateEvent.call(:unfavorited_ad, user: current_user, data: { ad_id: params[:id] })
        render(json: { message: :ok })
      end
    end
  end
end
