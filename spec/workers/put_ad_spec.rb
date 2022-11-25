# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(PutAd) do
  it 'requires base64(zip(ad_params))' do
    expect { subject.perform("INVALID") }.to(raise_error(ArgumentError, /invalid base64/))
  end
end
