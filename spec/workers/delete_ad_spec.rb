# frozen_string_literal: true

require "rails_helper"

RSpec.describe(DeleteAd) do
  let(:ad) { create(:ad, :active) }

  it "updates Ad#delete to true" do
    expect { subject.perform(ad.address) }.to(change { ad.reload.deleted? }.from(false).to(true))
  end
end
