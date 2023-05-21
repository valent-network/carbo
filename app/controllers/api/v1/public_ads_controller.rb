# frozen_string_literal: true

module Api
  module V1
    class PublicAdsController < ApplicationController
      def show
        ad = Ad.find(params[:id])

        render(json: AdSerializer.new(ad).as_json.except(:friend_name_and_total, :prices, :url, :images))
      end
    end
  end
end
