# frozen_string_literal: true
class AdsController < ApplicationController
  def show
    @ad = Ad.find(params[:id])
    @options = AdCarOptionsPresenter.new.call(@ad.details)
    @main_image = @ad.details['images_json_array_tmp'].is_a?(Array) ? @ad.details['images_json_array_tmp'].first : JSON.parse(@ad.details['images_json_array_tmp']).first
    @meta_title = "#{@ad.details['maker']} #{@ad.details['model']} #{@ad.details['year']}"
    render('ads/show', layout: false)
  end
end
