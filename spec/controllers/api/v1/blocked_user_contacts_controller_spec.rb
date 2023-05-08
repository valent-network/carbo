# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::BlockedUserContactsController) do
  let(:user) { create(:user) }
  let(:user_contact) { create(:user_contact, user: user) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe "#update" do
    it "creates blocked phone number" do
      expect { put(:update, params: {id: user_contact.id}) }.to(change { user.user_blocked_phone_numbers.count }.from(0).to(1))
      expect(response).to(be_ok)
    end

    it "removes blocked phone number" do
      create(:user_blocked_phone_number, user: user, phone_number: user_contact.phone_number)
      expect { put(:update, params: {id: user_contact.id}) }.to(change { user.user_blocked_phone_numbers.count }.from(1).to(0))
      expect(response).to(be_ok)
    end
  end
end
