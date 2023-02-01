# frozen_string_literal: true

module Api
  module V2
    class AdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.eager_load(:ads_source, :ad_images, :ad_image_links_set, :ad_description, :ad_extra, :ad_query, :ad_image_links_set, :ad_prices, :city, :region, :category).find(params[:id])
        AdVisitedJob.perform_async(current_user.id, ad.id)
        CreateEvent.call(:visited_ad, user: current_user, data: { ad_id: ad.id })

        ads_with_friends_sql = AdsWithFriendsQuery.new.call(current_user, [ad.phone_number_id])
        ads_with_friends = Ad.find_by_sql(ads_with_friends_sql)

        if current_user.phone_number_id == ad.phone_number_id
          ad.my_ad!
        else
          ad.associate_friends_with(ads_with_friends)
        end

        payload = AdSerializer.new(ad).as_json
        payload[:favorite] = current_user.ad_favorites.where(ad: ad).exists?

        render(json: payload)
      end

      def create
        ad = current_user.ads.new(phone_number_id: current_user.phone_number_id)
        ad.ads_source = AdsSource.where(native: true).first
        ad.assign_attributes(ad_params)

        if ad.save
          ad.my_ad!
          serialized_ad = ActiveModelSerializers::SerializableResource.new(ad, each_serializer: AdSerializer).as_json
          params[:ad][:tmp_images].each do |tmp_image|
            FinalizeAdImage.perform_async(ad.id, tmp_image[:key], tmp_image[:position])
          end
          render(json: serialized_ad)
        else
          error!('AD_VALIDATION_FAILED', :unprocessable_entity, ad.errors.full_messages.join("\n"))
        end
      end

      def update
        ad = current_user.ads.eager_load(:ads_source, :ad_images, :ad_description, :ad_extra, :ad_query, :ad_image_links_set, :ad_prices, :city, :region, :category).find(params[:id])
        ad.assign_attributes(ad_params)

        if ad.save
          ad.my_ad!
          serialized_ad = ActiveModelSerializers::SerializableResource.new(ad, each_serializer: AdSerializer).as_json
          NativizedProviderAd.where(address: ad.address).first_or_create unless ad.ads_source.native?
          params[:ad][:tmp_images]&.each do |tmp_image|
            FinalizeAdImage.perform_async(ad.id, tmp_image[:key], tmp_image[:position])
          end
          render(json: serialized_ad)
        else
          error!('AD_VALIDATION_FAILED', :unprocessable_entity, ad.errors.full_messages.join("\n"))
        end
      end

      def destroy
        ad = current_user.ads.includes(:ad_query, :ad_images, :ad_description, :ad_image_links_set, :ad_extra, :ads_source).find(params[:id])

        ad.chat_rooms.update_all(ad_title: ad.title)
        ad.destroy

        NativizedProviderAd.where(address: ad.address).first_or_create unless ad.ads_source.native?

        render(json: { message: :ok })
      end

      private

      def ad_params
        to_permit = [
          :price,
          :category_id,
          :city_id,
          :deleted,
          ad_query_attributes: [:title],
          ad_description_attributes: [:body, :short],
          ad_images_attributes: [:id, :position, :_destroy], # TODO: scope?
        ]

        params.require(:ad).permit(to_permit).tap do |t|
          if params[:ad] && params[:ad][:ad_extra_attributes] && params[:ad][:ad_extra_attributes][:details]
            t[:ad_extra_attributes] = {
              details: params[:ad][:ad_extra_attributes][:details].permit!,
            }
          end
        end
      end
    end
  end
end
