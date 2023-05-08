# frozen_string_literal: true

require "rails_helper"

RSpec.describe(SnapshotUserVisibility) do
  it "creates Event" do
    create(:user)
    expect(Event).to(receive(:connection).once.and_call_original)
    subject.perform
  end
end
