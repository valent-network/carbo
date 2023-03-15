# frozen_string_literal: true
class AmplitudeClient
  ENDPOINT = 'https://api2.amplitude.com/2/httpapi'

  def initialize(api_key)
    @api_key = api_key
  end

  def ready?
    @api_key.present?
  end

  def send_event(amplitude_event)
    Net::HTTP.post(URI.parse(ENDPOINT), { api_key: @api_key, events: [amplitude_event.to_json] }.to_json)
  end
end
