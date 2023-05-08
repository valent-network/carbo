# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationCable::UserChannel) do
  let(:user) { create(:user) }

  before do
    stub_connection current_user: user
  end

  it "Subscribed for User specific stream" do
    subscribe

    expect(subscription).to(be_confirmed)
    expect(subscription).to(have_stream_for(user))
  end
end
