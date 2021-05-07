# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdCarOptionsPresenter) do
  let(:ad) { create(:ad, :active) }
  subject { described_class.new.call(ad.new_details) }

  it { is_expected.to(be_a(Hash)) }

  it 'returns raw values' do
    ad.details = { 'gear' => 'g', 'wheels' => 'w', 'carcass' => 'cc', 'color' => 'cl' }
    PrepareAdOptions.new.call(ad, ad.details)
    ad.save
    is_expected.to(eq(
      gear: [I18n.t('ad_options.gear'), 'g'],
      wheels: [I18n.t('ad_options.wheels'), 'w'],
      carcass: [I18n.t('ad_options.carcass'), 'cc'],
      color: [I18n.t('ad_options.color'), 'cl']
    ))
  end

  it 'returns region' do
    ad.details = { region: ['Region', 'City'] }
    PrepareAdOptions.new.call(ad, ad.details)
    ad.save
    is_expected.to(eq(
      city: [I18n.t('ad_options.city'), 'City']
    ))
  end

  it 'transforms engine_capacity + fuel => engine' do
    ad.details = { engine_capacity: '1400', fuel: 'Diesel' }
    PrepareAdOptions.new.call(ad, ad.details)
    ad.save
    is_expected.to(eq(
      engine: [I18n.t('ad_options.engine'), I18n.t('ad_options.engine_value', value: '1.4', fuel_type: 'Diesel')]
    ))
  end

  it 'transforms race' do
    ad.details = { race: 100_000 }
    PrepareAdOptions.new.call(ad, ad.details)
    ad.save
    is_expected.to(eq(
      race: [I18n.t('ad_options.race'), I18n.t('ad_options.race_value', value: 100)]
    ))
  end
end
