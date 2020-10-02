# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(SendUserVerificationJob) do
  it 'works' do
    expect(TurboSMS).to(receive(:send_sms))
    phone_number = create(:phone_number)
    subject.perform(phone_number.id)
  end
end
