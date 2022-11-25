# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ActualizeAd) do
  it 'class StaleAddresses' do
    expect(StaleAddresses).to(receive(:call).and_call_original)
    subject.perform
  end
end
