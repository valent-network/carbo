# frozen_string_literal: true

require "rails_helper"

RSpec.describe(SendSystemMessageToAdmins) do
  let(:user) { create(:user, admin: true) }

  it "sends message to admin user set via ENV variable" do
    expect_any_instance_of(SendSystemMessageToChatRoom).to(receive(:call).with(user_id: user.id, message_text: "arbitary text"))
    subject.call("arbitary text")
  end
end
