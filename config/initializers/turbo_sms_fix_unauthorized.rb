# frozen_string_literal: true
# https://gist.github.com/yanaizmene/d721a7d8393d9c6a6c74f06063ab48dd
# https://github.com/vitalikdanchenko/turbosms/issues/4

module TurboSMS
  class << self
    def send_sms(destination, text = nil, sender = nil)
      authorize

      message = {
        sender: sender || default_options[:sender],
        destination: destination,
        text: text,
      }
      result = authorised_call(:send_sms, message: message)
      raise SendingSMSError, result unless result.instance_of?(Array)
      result[1] # message id
    end
  end
end
