# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ChatRoomUser) do
  subject { create(:chat_room_user) }

  context "On callbacks" do
    context "after_touch" do
      it "broadcasts #unread_update to ActionCable for User" do
        expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(subject.user, {type: "unread_update", count: 0}))
        subject.touch
      end
    end
  end
end
