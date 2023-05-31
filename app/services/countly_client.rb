# frozen_string_literal: true

class CountlyClient
  ENDPOINT = ENV["COUNTLY_ENDPOINT"]

  def initialize(api_key)
    @api_key = api_key
  end

  def ready?
    ENDPOINT.present? && @api_key.present?
  end

  def send_event(countly_event)
    body = countly_event.as_json.merge(app_key: @api_key).to_json
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => @api_key
    }
    response = Net::HTTP.post(URI.parse("#{ENDPOINT}/i"), body, headers)
    unless response.code == "200"
      Sentry.capture_message("[CountlyClient#send_event] event=#{countly_event.as_json.to_json} response=#{response.body}", level: :error)
    end
    response
  end
end
