# frozen_string_literal: true

module Api
  module V1
    class PublicAdsController < ApplicationController
      def show
        ad = if /\A\d+\Z/.match?(params[:id])
          Ad.find_by(id: params[:id])
        else
          Ad.find_by(address: "https://recar.io/ads/#{params[:id]}")
        end

        raise ActiveRecord::RecordNotFound.new(params[:id]) unless ad

        render(json: AdSerializer.new(ad).as_json.except(:friend_name_and_total, :prices, :url, :images))
      end
    end
  end
end
