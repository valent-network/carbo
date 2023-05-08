# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PhoneNumber) do
  it "#to_s"
  it "#demo?"
  it "#demo"
  it "#demo="
  it "has_many ads"
  it "has_many user_contacts"
  it "has_one user"
  it "has_one demo_phone_number"
  it "valid OPERATORS"

  describe "Validates" do
    it "#full_number"
  end

  describe ".by_full_number" do
    it "works for existing number" do
      num = "931234567"
      create(:phone_number, full_number: num)
      expect(described_class.by_full_number(num).count).to(eq(1))
    end

    it "works for invalid numbers but returns nothing" do
      expect(described_class.by_full_number("555-555-123").count).to(eq(0))
    end

    context "works with .first_or_create Rails method number (on Ruby 3) when" do
      it "phone number is valid" do
        expect(described_class.by_full_number("+380931234567").first_or_create).to(be_persisted)
      end

      it "phone number is invalid" do
        expect(described_class.by_full_number("(555) 564-8583").first_or_create).not_to(be_valid)
      end
    end
  end
end
