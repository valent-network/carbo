# frozen_string_literal: true

class AdsController < ApplicationController
  def show
    @ad = Ad.find(params[:id])
    @options = AdCarOptionsPresenter.new.call(@ad.details)
    @main_image = case @ad.details["images_json_array_tmp"]
    when Array
      @ad.details["images_json_array_tmp"].first
    when String
      begin JSON.parse(@ad.details["images_json_array_tmp"]).first
      rescue
        ""
      end
    else
      ""
    end

    @meta_title = @ad.title
    render("ads/show", layout: false)
  end
end
