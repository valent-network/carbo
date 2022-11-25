# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(SnapshotSystemStats) do
  it "creates SystemStat record" do
    DashboardStats.refresh(concurrently: false)
    expect { subject.perform }.to(change(SystemStat, :count).by(1))
  end
end
