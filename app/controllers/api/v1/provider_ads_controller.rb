# frozen_string_literal: true

module Api
  module V1
    class ProviderAdsController < ApplicationController
      before_action :require_provider

      def index
        render(json: [])

        # ads = Ad.where(ads_source_id: current_ads_source.id).where('updated_at < ?', 12.hours.ago)

        # effective_ads = ads.joins('JOIN effective_ads ON effective_ads.id = ads.id')

        # ads = if effective_ads.exists?
        #   effective_ads
        # else
        #   ads.where('ads.phone_number_id IN (SELECT phone_number_id FROM user_contacts)')
        # end

        # rel = ads.distinct('ads.id').limit(10)
        # rel.touch_all
        # addresses = rel.pluck(:address)

        # render(json: addresses)
      end

      def update_ad
        address = params[:ad][:details][:address]
        ad = Ad.where(address: address, ads_source_id: current_ads_source.id).first_or_initialize

        ad_contract = AdCarContract.new.call(params.permit!.to_h[:ad])

        return render(json: { errors: ad_contract.errors.to_h }, status: :unprocessable_entity) if ad_contract.failure?

        ad.assign_attributes(ad_params)
        PrepareAdOptions.new.call(ad, ad_details_params)

        if ad.save
          ad.touch
          render(json: { id: ad.id, address: address, deleted: ad.deleted })
        else
          render(json: { errors: ad.errors.to_hash }, status: :unprocessable_entity)
        end
      end

      def delete_ad
        address = params[:ad][:details][:address]
        ad = Ad.where(address: address, ads_source_id: current_ads_source.id).first
        if ad
          ad.update!(deleted: true)
          ad.touch
          render(json: { id: ad.id, address: address, deleted: ad.deleted })
        else
          # Airbrake.notify(address)
          render(json: { error: 'invalid URL' }, status: :unprocessable_entity)
        end
      end

      private

      def ad_params
        params.require(:ad).permit([:price, :phone, :ad_type])
      end

      def ad_details_params
        params.require(:ad).require(:details).permit(%i[maker model race year images_json_array_tmp engine_capacity fuel horse_powers gear wheels carcass color description state_num seller_name].push(region: []))
      end
    end
  end
end
