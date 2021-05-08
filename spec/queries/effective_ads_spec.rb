# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(EffectiveAds) do
  let!(:other_ads) do
    o_ads = create_list(:ad, 5, :car, :active)
    o_ads.each do |ad|
      ad.details['maker'] = 'Mercedes-Benz' if ad.details['maker'] == 'BMW'
      ad.details['model'] = 'GLE Coupe' if ad.details['model'] == 'X6'
      ad.details['year'] = (1970..1990).to_a.sample
      ad.price = (19_700..29_900).to_a.sample
      PrepareAdOptions.new.call(ad, ad.details)
      ad.save
    end

    o_ads
  end

  let!(:expected_ads) do
    e_ads = create_list(:ad, 2, :car, :active)
    e_ads.each do |ad|
      ad.details['year'] = 2016
      ad.details['maker'] = 'BMW'
      ad.details['model'] = 'X6'
      ad.details['wheels'] = '4x4'
      ad.details['gear'] = 'A'
      ad.details['fuel'] = 'B'
      ad.details['carcass'] = 'C'
      ad.price = (119_700..129_900).to_a.sample
      PrepareAdOptions.new.call(ad, ad.details)
      ad.save
    end

    e_ads
  end
  before(:each) do
    user = create(:user)
    [other_ads, expected_ads].flatten.each do |ad|
      user.user_contacts.create(phone_number: ad.phone_number, name: FFaker::Name.name)
    end

    EffectiveAd.refresh

    expect(EffectiveAd.count).to(eq(7))
  end

  subject do
    sql = described_class.new.call(filters: filters, should_search_query: should_search_query)
    ids = Ad.find_by_sql(sql).pluck(:id)
    Ad.find(ids)
  end

  context 'with #should_search_query = false' do
    let(:should_search_query) { false }

    context 'with no filters' do
      let(:filters) { {} }

      it 'returns all records from effective_ads table (matview)' do
        expect(subject.pluck(:id)).to(match_array([other_ads.pluck(:id), expected_ads.pluck(:id)].flatten))
      end

      it 'returns all unique records' do
        expect(subject.pluck(:id)).to(match_array(subject.pluck(:id).uniq))
      end
    end

    context 'with filter for fuel' do
      let(:filters) { { fuels: ['B'] } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['fuel']).to(eq('B'))
        end
      end
    end

    context 'with filter for gear' do
      let(:filters) { { gears: ['A'] } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['gear']).to(eq('A'))
        end
      end
    end

    context 'with filter for wheels' do
      let(:filters) { { wheels: ['4x4'] } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['wheels']).to(eq('4x4'))
        end
      end
    end

    context 'with filter for carcasses' do
      let(:filters) { { carcasses: ['C'] } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['carcass']).to(eq('C'))
        end
      end
    end

    context 'with filter for carcasses with multiple values' do
      let(:filters) { { carcasses: ['C', 'A'], fuel: ['B'] } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['carcass']).to(eq('C'))
        end
      end
    end

    context 'with filter for min_price' do
      let(:filters) { { min_price: 119_700 } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.price).to(be >= 119_700)
        end
      end
    end

    context 'with filter for max_price' do
      let(:filters) { { max_price: 119_699 } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(5))
        subject.each do |ad|
          expect(ad.price).to(be <= 119_700)
        end
      end
    end

    context 'with filter for min_price and max_price' do
      let(:filters) { { min_price: 119_700, max_price: 129_900 } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.price).to(be >= 119_700)
        end
      end
    end

    context 'with filter for min_year' do
      let(:filters) { { min_year: 2010 } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['year'].to_i).to(be >= 2010)
        end
      end
    end

    context 'with filter for max_year' do
      let(:filters) { { max_year: 2010 } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(5))
        subject.each do |ad|
          expect(ad.new_details['year'].to_i).to(be <= 2010)
        end
      end
    end

    context 'with filter for min_year and max_year' do
      let(:filters) { { max_year: 2020, min_year: 2010 } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['year'].to_i).to(be >= 2010)
        end
      end
    end
  end

  context 'with #should_search_query = true' do
    let(:should_search_query) { true }

    context 'with filter for query (maker)' do
      let(:filters) { { query: 'BMW' } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['maker']).to(eq('BMW'))
          expect(ad.new_details['model']).to(eq('X6'))
        end
      end
    end

    context 'with filter for query (model)' do
      let(:filters) { { query: 'X6' } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['maker']).to(eq('BMW'))
          expect(ad.new_details['model']).to(eq('X6'))
        end
      end
    end

    context 'with filter for query (year)' do
      let(:filters) { { query: '2016' } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['maker']).to(eq('BMW'))
          expect(ad.new_details['model']).to(eq('X6'))
        end
      end
    end

    context 'with filter for query (maker + model + year)' do
      let(:filters) { { query: 'BMW X6 2016' } }

      it 'returns only expected records' do
        expect(subject.count).to(eq(2))
        subject.each do |ad|
          expect(ad.new_details['maker']).to(eq('BMW'))
          expect(ad.new_details['model']).to(eq('X6'))
        end
      end
    end

    context 'with filter for query (maker + model + year)' do
      let(:filters) { { query: 'BMW 2016 X6' } }

      it 'fails for wrong order' do
        expect(subject.count).to(eq(0))
      end
    end
  end
end
