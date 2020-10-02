# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdCarShortDescriptionPresenter) do
  let(:ad_details) do
    {
      race: 50_000,
      engine_capacity: 3700,
      year: 2014,
      gear: 'Manual',
      fuel: 'Gas',
      horse_powers: 333,
    }
  end
  let(:ad) { create(:ad, :active, details: ad_details) }
  subject { described_class.new.call(ad.details) }

  it { is_expected.to(be_a(String)) }

  it 'returns complete string' do
    expect(subject).to(eq('2014 год, 50 тыс. км, Manual, Gas 3.7 л, 333 л. с'))
  end
end
