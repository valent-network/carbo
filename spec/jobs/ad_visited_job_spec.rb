# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdVisitedJob) do
  let(:user) { create(:user) }
  let(:ad) { create(:ad, :active) }

  it 'works' do
    expect { subject.perform(user.id, ad.id) }.to(change { AdVisit.where(ad: ad, user: user).count }.from(0).to(1))
  end
end
