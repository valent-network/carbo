# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(SendUserVerificationJob) do
  let(:phone_number) { create(:phone_number) }

  it 'triggers TurboSMS#send_sms' do
    expect(TurboSMS).to(receive(:send_sms))

    subject.perform(phone_number.id)
  end
end
