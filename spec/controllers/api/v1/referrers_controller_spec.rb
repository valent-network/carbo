# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::ReferrersController) do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, name: "John") }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe "#show" do
    it "shows user when found" do
      get :show, params: {id: other_user.refcode}
      expect(response).to(be_ok)
      expect(json_body["name"]).to(eq(other_user.name))
    end

    it "shows nothing when not found" do
      get :show, params: {id: "INVALID"}
      expect(response).to(be_not_found)
      expect(json_body).to(be_empty)
    end
  end
end
