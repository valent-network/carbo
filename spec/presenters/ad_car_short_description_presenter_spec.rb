# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdCarShortDescriptionPresenter) do
  subject { described_class.new.call(ad.details) }

  let(:ad_details) do
    {
      race: 50_000,
      engine_capacity: 3700,
      year: 2014,
      gear: 'Manual',
      fuel: 'Gas',
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
    gear_opt_type = AdOptionType.find_by_name('gear')
    gear_opt_val = ad.ad_options.where(ad_option_type: gear_opt_type).first.ad_option_value
    create(:filterable_value, ad_option_type: gear_opt_type, ad_option_value: gear_opt_val, name: 'manual')

    fuel_opt_type = AdOptionType.find_by_name('fuel')
    fuel_opt_val = ad.ad_options.where(ad_option_type: fuel_opt_type).first.ad_option_value
    create(:filterable_value, ad_option_type: fuel_opt_type, ad_option_value: fuel_opt_val, name: 'lpg')

    create(:filterable_value_translation, ad_option_type: gear_opt_type, name: 'Manual', alias_group_name: 'manual', locale: 'en')
    create(:filterable_value_translation, ad_option_type: fuel_opt_type, name: 'Gas', alias_group_name: 'lpg', locale: 'en')
    # create(:filterable_value, ad_option_type: , )
    expect(subject).to(eq("50k\u00A0km, Manual, Gas\u00A03.7L, 333\u00A0h.p., Kharkiv\u00A0city"))
  end
end
