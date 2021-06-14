# frozen_string_literal: true
class PromoEventsController < ApplicationController
  layout 'network'

  def index
    @events = PromoEvent.page(params[:page])
    @events = @events.where(refcode: params[:refcode].strip.upcase) if params[:refcode].to_s.strip.size == 5
  end
end
