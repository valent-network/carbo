# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdCarOptionsPresenter) do
  subject { described_class.new.call(ad.details) }

  # let(:region) { create(:region, name: 'kh') }
  # let(:city) { create(:city, region: region) }
  let(:ad) { create(:ad, :active) }

  it { is_expected.to(be_a(Hash)) }

  it 'returns raw values' do
    ad.details = { 'gear' => 'g', 'wheels' => 'w', 'carcass' => 'cc', 'color' => 'cl', 'images_json_array_tmp' => ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: 'kh', city: 'city-kh' }
    ad.save

    gear_opt_type = AdOptionType.find_by_name('gear')
    gear_opt_val = ad.ad_options.where(ad_option_type: gear_opt_type).first.ad_option_value
    create(:filterable_value, ad_option_type: gear_opt_type, ad_option_value: gear_opt_val, name: 'g')
    create(:filterable_value_translation, ad_option_type: gear_opt_type, name: 'g', alias_group_name: 'g', locale: 'en')

    carcass_opt_type = AdOptionType.find_by_name('carcass')
    carcass_opt_val = ad.ad_options.where(ad_option_type: carcass_opt_type).first.ad_option_value
    create(:filterable_value, ad_option_type: carcass_opt_type, ad_option_value: carcass_opt_val, name: 'cc')
    create(:filterable_value_translation, ad_option_type: carcass_opt_type, name: 'cc', alias_group_name: 'cc', locale: 'en')

    wheels_opt_type = AdOptionType.find_by_name('wheels')
    wheels_opt_val = ad.ad_options.where(ad_option_type: wheels_opt_type).first.ad_option_value
    create(:filterable_value, ad_option_type: wheels_opt_type, ad_option_value: wheels_opt_val, name: 'w')
    create(:filterable_value_translation, ad_option_type: wheels_opt_type, name: 'w', alias_group_name: 'w', locale: 'en')

    color_opt_type = AdOptionType.find_by_name('color')
    color_opt_val = ad.ad_options.where(ad_option_type: color_opt_type).first.ad_option_value
    create(:filterable_value, ad_option_type: color_opt_type, ad_option_value: color_opt_val, name: 'cl')
    create(:filterable_value_translation, ad_option_type: color_opt_type, name: 'cl', alias_group_name: 'cl', locale: 'en')

    expect(subject).to(eq(
      gear: [I18n.t('ad_options.gear'), 'g'],
      wheels: [I18n.t('ad_options.wheels'), 'w'],
      carcass: [I18n.t('ad_options.carcass'), 'cc'],
      color: [I18n.t('ad_options.color'), 'cl'],
      location: [I18n.t('ad_options.location'), 'kh'],
    ))
  end

  it 'transforms engine_capacity + fuel => engine' do
    ad.details = { engine_capacity: '1400', fuel: 'Diesel', 'images_json_array_tmp' => ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: 'kh', city: 'city-kh' }
    ad.save

    fuel_opt_type = AdOptionType.find_by_name('fuel')
    fuel_opt_val = ad.ad_options.where(ad_option_type: fuel_opt_type).first.ad_option_value
    create(:filterable_value, ad_option_type: fuel_opt_type, ad_option_value: fuel_opt_val, name: 'diesel')
    create(:filterable_value_translation, ad_option_type: fuel_opt_type, name: 'Diesel', alias_group_name: 'diesel', locale: 'en')

    expect(subject).to(eq(
      engine: [I18n.t('ad_options.engine'), I18n.t('ad_options.engine_value', value: '1.4', fuel_type: 'Diesel')],
      location: [I18n.t('ad_options.location'), 'kh'],
    ))
  end

  it 'transforms race' do
    ad.details = { race: 100_000, 'images_json_array_tmp' => ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: 'kh', city: 'city-kh' }
    ad.save
    expect(subject).to(eq(
      race: [I18n.t('ad_options.race'), I18n.t('ad_options.race_value', value: 100)],
      location: [I18n.t('ad_options.location'), 'kh'],
    ))
  end
end
