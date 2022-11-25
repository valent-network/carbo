# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(SnapshotUserVisibility) do
  it 'creates Event' do
    create(:user)
    BusinessPhoneNumber.refresh(concurrently: false)
    expect(CreateEvent).to(receive(:call).once)
    subject.perform
  end
end
