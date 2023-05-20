# frozen_string_literal: true

require "rails_helper"

RSpec.describe(SnapshotSystemStats) do
  it "creates SystemStat record" do
    expect(REDIS).to receive(:get).with("dashboard_data").and_return("{}")
    expect { subject.perform }.to(change(SystemStat, :count).by(1))
  end
end
