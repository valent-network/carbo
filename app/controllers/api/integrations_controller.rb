class Api::IntegrationsController < ApplicationController
  DATA_TYPES = ["dashboard", "budget"].freeze

  before_action :check_cache

  def show
    render(json: {records: data, etag: etag})
  end

  private

  def check_cache
    return head 304 if etag.present? && params[:etag] == etag
  end

  def etag
    REDIS.get("#{data_type}_data.etag")
  rescue
    Sentry.capture_message("ETAG missing for #{data_type} integration", level: :error)
    nil
  end

  def data
    JSON.parse(REDIS.get("#{data_type}_data"))
  rescue
    Sentry.capture_message("Data missing for #{data_type} integration", level: :error)
    {}
  end

  def data_type
    data_type = request.path.split("/").last
    raise unless data_type.in?(DATA_TYPES)
    data_type
  end
end
