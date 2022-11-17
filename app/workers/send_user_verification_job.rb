# frozen_string_literal: true

class SendUserVerificationJob
  include Sidekiq::Worker

  sidekiq_options queue: 'sms', retry: true, backtrace: false

  def perform(phone_number_id)
    phone_number = PhoneNumber.find(phone_number_id)
    verification_code = Random.new.rand(1000..9999)
    phone_number_for_sms = Phonelib.parse(phone_number.full_number).full_e164
    request = VerificationRequest.joins(:phone_number).where(phone_numbers: { full_number: phone_number.full_number }).first_or_initialize(phone_number_id: phone_number.id)
    request.verification_code = verification_code
    request.save!
    body = I18n.t('send_verification.sms_text', verification_code: verification_code)

    CreateEvent.call('sms_send_attempt', user: nil, data: { phone_number_id: phone_number_id })

    begin
      TurboSMS.send_sms(phone_number_for_sms, body)
    rescue StandardError
      TurboSMS.send(:authorize)
      TurboSMS.send_sms(phone_number_for_sms, body)
    end
  end
end
