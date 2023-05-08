# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Message) do
  it "#unread_messages_for"
  it ".implicit_order_column"
  it "belongs_to user"
  it "belongs_to chat_room"
  it "has_one chat_room_user"

  describe "Validates" do
    it "#body"
  end
end
