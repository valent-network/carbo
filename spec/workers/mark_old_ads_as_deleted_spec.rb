# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(MarkOldAdsAsDeleted) do
  let(:ad) { create(:ad, :active) }

  it 'updates Ad#delete to true' do
    ad.update_column(:updated_at, 3.months.ago)
    expect { subject.perform }.to(change { ad.reload.deleted? }.from(false).to(true))
  end
end
