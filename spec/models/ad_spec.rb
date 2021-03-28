# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Ad, type: :model) do
  let(:ad) { create(:ad, :active) }

  describe '#associate_friends_with' do
    subject { ad.friend_name_and_total }

    it 'returns nil if no friends provided'

    it 'returns nil if friend not associated to ad (?)'

    it 'selects the closest-hand friend'

    it 'result count excludes associated friend'
  end

  describe '#details' do
    it 'must be JSON (set via Hash)' do
      ad.details = { some: :data }
      expect(ad.valid?).to(be_truthy)
    end

    it 'throws validation error in case of JSON is an array, not object' do
      ad.details = [1, 2, 3]
      expect(ad.valid?).to(be_falsey)
      expect(ad.errors.to_hash[:details]).to(eq(['must be a Hash']))
    end

    it 'must NOT be JSON String' do
      ad.details = '{"some": "data"}'
      expect(ad.valid?).to(be_falsey)
      expect(ad.errors.to_hash[:details]).to(eq(['must be a Hash']))
    end

    it 'throws validation error in case of invalid JSON format' do
      ad.details = 'invalid'
      expect(ad.valid?).to(be_falsey)
      expect(ad.errors.to_hash[:details]).to(eq(['is invalid', 'must be a Hash']))
    end
  end

  describe '#ad_prices' do
    it 'creates AdPrice record on price update' do
      expect { ad.update(price: ad.price + 1000) }.to(change { ad.reload.ad_prices.count }.from(0).to(1))
    end

    it 'does not create AdPrice record when Ad was updated but not price' do
      expect { ad.update(deleted: true) }.to_not(change { ad.reload.ad_prices.count })
    end

    it 'does not create AdPrice record when Ad was created' do
      expect { create(:ad, :active) }.to_not(change { AdPrice.count })
    end
  end
end
