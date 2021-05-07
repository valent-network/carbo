# frozen_string_literal: true
class AdsController < ApplicationController
  def show
    @ad = Ad.find(params[:id])
    @options = AdCarOptionsPresenter.new.call(@ad.new_details)
    @main_image = case @ad.new_details['images_json_array_tmp']
    when Array
      @ad.new_details['images_json_array_tmp'].first
    when String
      begin JSON.parse(@ad.new_details['images_json_array_tmp']).first
      rescue
        ''
      end
    else
      ''
    end

    @meta_title = "#{@ad.new_details['maker']} #{@ad.new_details['model']} #{@ad.new_details['year']}"
    render('ads/show', layout: false)
  end
end
