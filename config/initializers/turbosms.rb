# frozen_string_literal: true

TurboSMS.default_options[:login] = ENV.fetch("TURBOSMS_LOGIN", "recario")
TurboSMS.default_options[:password] = ENV["TURBOSMS_PASSWORD"]
TurboSMS.default_options[:sender] = ENV.fetch("TURBOSMS_SENDER", "recar.io")
