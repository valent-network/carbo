# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdCarOptionsPresenter) do
  subject { described_class.new.call(ad.details) }

  let(:region) { create(:region, name: 'kh') }
  let(:city) { create(:city, region: region) }
  let(:ad) { create(:ad, :active, city: city) }

  it { is_expected.to(be_a(Hash)) }

  it 'returns raw values' do
    ad.details = { 'gear' => 'g', 'wheels' => 'w', 'carcass' => 'cc', 'color' => 'cl' }
    ad.save
    expect(subject).to(eq(
      gear: [I18n.t('ad_options.gear'), 'g'],
      wheels: [I18n.t('ad_options.wheels'), 'w'],
      carcass: [I18n.t('ad_options.carcass'), 'cc'],
      color: [I18n.t('ad_options.color'), 'cl'],
      location: [I18n.t('ad_options.location'), 'kh']
    ))
  end

  it 'transforms engine_capacity + fuel => engine' do
    ad.details = { engine_capacity: '1400', fuel: 'Diesel' }
    ad.save
    expect(subject).to(eq(
      engine: [I18n.t('ad_options.engine'), I18n.t('ad_options.engine_value', value: '1.4', fuel_type: 'Diesel')],
      location: [I18n.t('ad_options.location'), 'kh'],
    ))
  end

  it 'transforms race' do
    ad.details = { race: 100_000 }
    ad.save
    expect(subject).to(eq(
      race: [I18n.t('ad_options.race'), I18n.t('ad_options.race_value', value: 100)],
      location: [I18n.t('ad_options.location'), 'kh'],
    ))
  end
end
