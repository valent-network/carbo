# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(StaleAddresses) do
  subject { described_class.call }

  it { is_expected.to(eq([])) }
end
