# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdVisitedJob) do
  subject { described_class.new.perform(user.id, ad.id) }

  let(:user) { create(:user) }
  let(:ad) { create(:ad, :active) }

  it 'creates AdVisit record in database' do
    expect { subject }.to(change { AdVisit.where(ad: ad, user: user).count }.from(0).to(1))
  end
end
