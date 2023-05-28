# frozen_string_literal: true

module Api
  module V1
    class PublicAdsController < ApplicationController
      def show
        ad = Ad.find_by(id: params[:id]) || Ad.find_by(address: "https://recar.io/ads/#{params[:id]}")

        render(json: AdSerializer.new(ad).as_json.except(:friend_name_and_total, :prices, :url, :images))
      end
    end
  end
end
