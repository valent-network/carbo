# frozen_string_literal: true

require "rails_helper"

RSpec.describe(DeleteOldVerificationRequests) do
  let(:vr) { create(:verification_request) }

  it "deletes record if old" do
    vr.update_column(:updated_at, 3.hours.ago)
    expect { subject.perform }.to(change { VerificationRequest.where(id: vr.id).exists? }.from(true).to(false))
  end
end
