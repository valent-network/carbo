# frozen_string_literal: true

module Api
  module V1
    class PublicAdsController < ApplicationController
      def show
        ad = Ad.find(params[:id])
        main_image = case ad.details["images_json_array_tmp"]
        when Array
          ad.details["images_json_array_tmp"].first
        when String
          begin
            JSON.parse(ad.details["images_json_array_tmp"]).first
          rescue
            ""
          end
        else
          ""
        end

        payload = {
          ad: ad.as_json,
          ad_options: AdCarOptionsPresenter.new.call(ad.details),
          main_image: main_image
        }

        render(json: payload)
      end
    end
  end
end
