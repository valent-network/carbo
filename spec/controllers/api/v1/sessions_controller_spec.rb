# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::SessionsController) do
  let(:user) { create(:user) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
    allow(subject).to(receive(:current_device).and_return(create(:user_device, user: user)))
  end

  describe "#create" do
    it "OK" do
      post :create, params: {phone_number: user.phone_number.to_s}
      expect(response).to(be_ok)
    end

    context "With invalid params" do
      it "can not be blank" do
        post :create, params: {phone_number: ""}
        expect(response).to(be_unprocessable)
        expect(json_body["message"]).to(eq("error"))
        expect(json_body["errors"]).to(match({"full_number" => ["is invalid"]}))
      end

      it "invalid format" do
        post :create, params: {phone_number: "+1123456789"}
        expect(response).to(be_unprocessable)
        expect(json_body["message"]).to(eq("error"))
        expect(json_body["errors"]).to(match({"full_number" => ["is invalid"]}))
      end
    end
  end

  describe "#update" do
    it "OK" do
      verification_code = 1234
      create(:verification_request, phone_number: user.phone_number, verification_code: verification_code)
      put :update, params: {phone_number: user.phone_number.to_s, verification_code: verification_code, device_id: SecureRandom.hex}
      expect(response).to(be_ok)
    end

    context "With DEMO phone number" do
      before do
        create(:demo_phone_number, phone_number: user.phone_number, demo_code: 2008)
      end

      it "works with demo code" do
        put :update, params: {phone_number: user.phone_number.to_s, verification_code: 2008, device_id: SecureRandom.hex}
        expect(response).to(be_ok)
      end
    end
  end

  describe "#destroy" do
    it "OK" do
      delete :destroy
      expect(response).to(be_ok)
    end

    context "With no user" do
      before do
        allow(subject).to(receive(:current_user).and_return(nil))
        allow(subject).to(receive(:current_device).and_return(nil))
      end

      it "is unauthorized" do
        delete :destroy
        expect(response).to(be_unauthorized)
        expect(json_body["message"]).to(eq("Authorization required"))
      end
    end
  end
end
