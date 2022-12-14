# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdCarShortDescriptionPresenter) do
  subject { described_class.new.call(ad.details) }

  let(:ad_details) do
    {
      race: 50_000,
      engine_capacity: 3700,
      year: 2014,
      gear: 'Manual Transmission',
      fuel: 'Methane Gas',
      horse_powers: 333,
      images_json_array_tmp: ["#{FFaker::Image.url}#{SecureRandom.hex}"],
      region: 'kh',
      city: 'Kharkiv',
    }
  end
  let(:ad) do
    a = create(:ad, :active)
    a.details = ad_details
    a.save
    a
  end

  it { is_expected.to(be_a(String)) }

  it 'returns complete string' do
    create(:filterable_value, ad_option_type: AdOptionType.find_by_name('gear'), name: 'manual', raw_value: 'Manual Transmission')
    create(:filterable_value, ad_option_type: AdOptionType.find_by_name('fuel'), name: 'lpg', raw_value: 'Methane Gas')

    expect(subject).to(eq("50k\u00A0km, Manual, LPG\u00A03.7L, 333\u00A0h.p., Kharkiv\u00A0city"))
  end
end
