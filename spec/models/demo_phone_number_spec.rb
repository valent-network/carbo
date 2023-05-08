# frozen_string_literal: true

require "rails_helper"

RSpec.describe(DemoPhoneNumber) do
  let(:phone_number) { create(:phone_number) }
  let(:another_phone_number) { create(:phone_number) }
  let(:demo_phone_number) { create(:demo_phone_number, phone_number: phone_number) }

  describe "#phone" do
    it "shows count of user.user_contacts" do
      expect(demo_phone_number.phone).to(eq(phone_number.to_s))
    end
  end

  describe "#phone=" do
    it "shows count of user.user_contacts" do
      expect { demo_phone_number.update(phone: another_phone_number.to_s) }.to(change { demo_phone_number.reload.phone_number.id }.from(phone_number.id).to(another_phone_number.id))
    end
  end
end
