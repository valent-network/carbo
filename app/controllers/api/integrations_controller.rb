class Api::IntegrationsController < ApplicationController
  DATA_TYPES = ["dashboard", "budget"].freeze

  before_action :check_cache

  def show
    render(json: {records: data, etag: @etag})
  end

  private

  def check_cache
    return head 304 if etag.present? && params[:etag] == etag
  end

  def etag
    REDIS.get("#{data_type}_data.etag")
  end

  def data
    JSON.parse(REDIS.get("#{data_type}_data"))
  end

  def data_type
    data_type = request.path.split("/").last
    raise unless data_type.in?(DATA_TYPES)
    data_type
  end
end
