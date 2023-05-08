# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::MessageSerializer) do
  it "#_id"
  it "#chat_room_id"
  it "#text"
  it "#user"
  it "#user may have no #name"
  it "#pending"
  it "#createdAt"
end
