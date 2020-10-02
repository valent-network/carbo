# frozen_string_literal: true

class SendUserVerificationJob < ApplicationJob
  queue_as :sms

  def perform(phone_number_id)
    phone_number = PhoneNumber.find(phone_number_id)
    verification_code = Random.new.rand(1000..9999)
    phone_number_for_sms = Phonelib.parse(phone_number.full_number).full_e164
    request = VerificationRequest.joins(:phone_number).where(phone_numbers: { full_number: phone_number.full_number }).first_or_initialize(phone_number_id: phone_number.id)
    request.verification_code = verification_code
    request.save!
    body = I18n.t('send_verification.sms_text', verification_code: verification_code)
    TurboSMS.send_sms(phone_number_for_sms, body)
  end
end
