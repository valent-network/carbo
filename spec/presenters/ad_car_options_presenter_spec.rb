# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdCarOptionsPresenter) do
  let(:ad) { create(:ad, :active) }
  subject { described_class.new.call(ad.details) }

  it { is_expected.to(be_a(Hash)) }

  it 'returns raw values' do
    ad.update(details: { 'gear' => 'g', 'wheels' => 'w', 'carcass' => 'cc', 'color' => 'cl' })
    is_expected.to(eq(
      gear: [I18n.t('ad_options.gear'), 'g'],
      wheels: [I18n.t('ad_options.wheels'), 'w'],
      carcass: [I18n.t('ad_options.carcass'), 'cc'],
      color: [I18n.t('ad_options.color'), 'cl']
    ))
  end

  it 'returns region' do
    ad.update(details: { region: ['Region', 'City'] })
    is_expected.to(eq(
      city: [I18n.t('ad_options.city'), 'City']
    ))
  end

  it 'transforms engine_capacity + fuel => engine' do
    ad.update(details: { engine_capacity: '1400', fuel: 'Diesel' })
    is_expected.to(eq(
      engine: [I18n.t('ad_options.engine'), I18n.t('ad_options.engine_value', value: '1.4', fuel_type: 'Diesel')]
    ))
  end

  it 'transforms race' do
    ad.update(details: { race: 100_000 })
    is_expected.to(eq(
      race: [I18n.t('ad_options.race'), I18n.t('ad_options.race_value', value: 100)]
    ))
  end
end
