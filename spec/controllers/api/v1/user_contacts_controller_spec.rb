# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::UserContactsController) do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  before do
    create(:user_contact, user: user, phone_number: another_user.phone_number)
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe "#index" do
    it "OK" do
      get :index
      expect(response).to(be_ok)
    end
  end
end
