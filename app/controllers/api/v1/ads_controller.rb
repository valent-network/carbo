# frozen_string_literal: true

module Api
  module V1
    class AdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.eager_load(:ad_description, :ad_extra, :ad_query, :ad_image_links_set, :ad_prices, :city, :region).find(params[:id])
        AdVisitedJob.perform_async(current_user.id, ad.id)
        CreateEvent.call(:visited_ad, user: current_user, data: { ad_id: ad.id })

        ads_with_friends_sql = AdsWithFriendsQuery.new.call(current_user, [ad.phone_number_id])
        ads_with_friends = Ad.find_by_sql(ads_with_friends_sql)

        ad.associate_friends_with(ads_with_friends)

        payload = AdSerializer.new(ad).as_json
        payload[:is_favorite] = current_user.ad_favorites.where(ad: ad).exists?

        render(json: payload)
      end

      def create
        ad = current_user.ads.new(phone_number_id: current_user.phone_number_id)
        ad.assign_attributes(ad_params)

        if ad.save
          render(json: ad)
        else
          error!('AD_VALIDATION_FAIELD', :unprocessable_entity, ad.errors.as_json)
        end

        ad.save!
      end

      def update
        ad = current_user.ads.find(params[:id])
        ad.assign_attributes(ad_params)

        if ad.save
          render(json: ad)
          NativizedProviderAd.where(address: ad.address).first_or_create unless ad.ads_source.native?
        else
          error!('AD_VALIDATION_FAIELD', :unprocessable_entity, ad.errors.as_json)
        end

        ad.save!
      end

      def destroy
        ad = current_user.ads.find(params[:id])

        ad.destroy

        NativizedProviderAd.where(address: ad.address).first_or_create unless ad.ads_source.native?

        render(json: { message: :ok })
      end

      private

      def ad_params
        params.require(:ad).permit(:price, :category_id, :city_id, ad_query_attributes: [:title], ad_description_attributes: [:body, :short]).tap do |para|
          para[:ad_extra_attributes] = { details: params[:ad][:ad_extra_attributes][:details].permit! }
        end
      end
    end
  end
end
