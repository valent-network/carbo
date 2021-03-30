# frozen_string_literal: true

module Api
  module V1
    class ProviderAdsController < ApplicationController
      before_action :require_provider

      def index
        ads = Ad.where(ads_source_id: current_ads_source.id).where('updated_at < ?', 12.hours.ago)
        ads = ads.joins('JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id')
        ads = ads.limit(10).order(Arel.sql("deleted = 'f' DESC, updated_at")).pluck(:address)

        render(json: ads)
      end

      def update_ad
        ad = Ad.where(address: ad_params[:details][:address], ads_source_id: current_ads_source.id).first_or_initialize

        ad_contract = AdCarContract.new.call(params.permit!.to_h[:ad])

        return render(json: { errors: ad_contract.errors.to_h }, status: :unprocessable_entity) if ad_contract.failure?

        PrepareAdOptions.new.call(ad, ad_params[:details])

        if ad.update(ad_params)
          render(json: { ad: ad })
          ad.touch
        else
          render(json: { errors: ad.errors.to_hash }, status: :unprocessable_entity)
        end
      end

      def delete_ad
        ad = Ad.where(address: ad_params[:details][:address], ads_source_id: current_ads_source.id).first
        if ad
          ad.update!(deleted: true)
          ad.touch
          render(json: { ad: ad })
        else
          # Airbrake.notify(ad_params[:details][:address])
          render(json: { error: 'invalid URL' }, status: :unprocessable_entity)
        end
      end

      private

      def ad_params
        details_params = %i[maker model race address new_car customs_clear year images_json_array_tmp engine_capacity fuel horse_powers gear wheels carcass color description state_num seller_name]
        details_params.push(region: [])
        to_permit = [:price, :deleted, :phone, :ad_type, :address, details: details_params]
        params.require(:ad).permit(to_permit)
      end
    end
  end
end
