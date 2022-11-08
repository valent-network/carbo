# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(PrepareAdOptions) do
  let(:ad) { create(:ad, :active) }

  it 'creates records on update(AdOption, AdOptionType, AdOptionValue)' do
    expect do
      subject.call(ad, { ad_type: 'car', new_option: 'new', images_json_array_tmp: ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: '1', city: '2' })
      ad.save
    end.to(change { AdOptionType.where(name: 'ad_type').count }.from(0).to(1)
      .and(change { AdOptionValue.where(value: 'car').count }.from(0).to(1)
      .and(change { ad.reload.ad_options.count }.from(10).to(2))))
  end

  it 'creates records on create' do
    expect do
      subject.call(ad, { new_option: 'car', images_json_array_tmp: ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: '1', city: '2' })
      ad.save
    end.to(change { AdOptionType.where(name: 'new_option').count }.from(0).to(1)
      .and(change { AdOptionValue.where(value: 'car').count }.from(0).to(1)
      .and(change(AdOption, :count).by(1))))
  end

  it 'destroys records if details value is blank' do
    subject.call(ad, { ad_type: 'car', images_json_array_tmp: ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: '1', city: '2' })
    ad.save!

    expect do
      subject.call(ad, { ad_type: nil, images_json_array_tmp: ["#{FFaker::Image.url}#{SecureRandom.hex}"], region: '1', city: '2' })
      ad.save!
    end.to(change { ad.reload.ad_options.count }.from(1).to(0))
  end

  pending 'destroys records missing in details object'

  pending 'updates records correctly'

  pending 'works for existing records'

  pending 'works for new records'

  pending 'does not update records on save (i.e. price change)'
end
