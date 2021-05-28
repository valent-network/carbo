# frozen_string_literal: true

FactoryBot.define do
  factory :ad do
    ads_source
    phone_number
    price { rand(1000..10000) }
    address { "http://example.com/ads/#{rand(1000000000)}" }
    ad_type { Ad::AD_TYPES.sample }
    deleted { [true, false].sample }
    details do
      {
        maker: FFaker::Vehicle.make,
        model: FFaker::Vehicle.model,
        race: rand(1..3000),
        year: FFaker::Vehicle.year,
        engine_capacity: (FFaker::Vehicle.engine_displacement.to_f * 1000),
        fuel: FFaker::Vehicle.fuel_type,
        gear: FFaker::Vehicle.transmission,
        wheels: FFaker::Vehicle.drivetrain,
        carcass: FFaker::Vehicle.interior_upholstery,
        region: [FFaker::AddressRU.province, FFaker::AddressRU.city],
        color: FFaker::Vehicle.mfg_color(0),
      }
    end

    trait :deleted do
      deleted { true }
    end

    trait :active do
      deleted { false }
    end

    trait :car do
      ad_type { 'car' }
    end
  end
end
