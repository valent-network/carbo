# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdCarOptionsPresenter) do
  subject { described_class.new.call(ad.details) }

  # let(:region) { create(:region, name: 'kh') }
  # let(:city) { create(:city, region: region) }
  let(:ad) { create(:ad, :active) }

  it { is_expected.to(be_a(Hash)) }

  it 'returns raw values' do
    ad.details = { 'gear' => 'g', 'wheels' => 'w', 'carcass' => 'cc', 'color' => 'Red Colour', 'images_json_array_tmp' => ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: 'kh', city: 'city-kh' }
    ad.save

    color_opt = AdOptionType.find_by_name('color')
    color_opt.update(filterable: true)

    create(:filterable_value, ad_option_type: AdOptionType.find_by_name('gear'), name: 'auto', raw_value: 'g')
    create(:filterable_value, ad_option_type: AdOptionType.find_by_name('carcass'), name: 'coupe', raw_value: 'cc')
    create(:filterable_value, ad_option_type: AdOptionType.find_by_name('wheels'), name: 'awd', raw_value: 'w')
    create(:filterable_value, ad_option_type: color_opt, name: 'red', raw_value: 'Red Colour')

    expect(subject).to(eq(
      gear: [I18n.t('ad_options.gear'), 'Automatic'],
      wheels: [I18n.t('ad_options.wheels'), '4x4'],
      carcass: [I18n.t('ad_options.carcass'), 'Coupe'],
      location: [I18n.t('ad_options.location'), "kh,\u00A0city-kh\u00A0city"],
      color: [I18n.t('ad_options.color'), 'Red'],
    ))
  end

  it 'transforms engine_capacity + fuel => engine' do
    ad.details = { engine_capacity: '1400', fuel: 'Diesel (raw)', 'images_json_array_tmp' => ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: 'kh', city: 'city-kh' }
    ad.save

    create(:filterable_value, ad_option_type: AdOptionType.find_by_name('fuel'), name: 'diesel', raw_value: 'Diesel (raw)')

    expect(subject).to(eq(
      engine: [I18n.t('ad_options.engine'), I18n.t('ad_options.engine_value', value: '1.4', fuel_type: 'Diesel')],
      location: [I18n.t('ad_options.location'), "kh,\u00A0city-kh\u00A0city"],
    ))
  end

  it 'transforms race' do
    ad.details = { race: 100_000, 'images_json_array_tmp' => ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: 'kh', city: 'city-kh' }
    ad.save
    expect(subject).to(eq(
      race: [I18n.t('ad_options.race'), I18n.t('ad_options.race_value', value: 100)],
      location: [I18n.t('ad_options.location'), "kh,\u00A0city-kh\u00A0city"],
    ))
  end
end
