# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ApplicationCable::Connection, type: :channel) do
  let(:user) { create(:user) }
  let(:user_device) { create(:user_device, user: user) }

  it 'successfully connects' do
    connect '/cable', params: { 'access_token' => user_device.access_token }
    expect(connection.current_user.id).to(eq(user.id))
  end

  it 'rejects connection' do
    expect { connect('/cable') }.to(have_rejected_connection)
  end
end
