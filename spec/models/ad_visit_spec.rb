# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdVisit, type: :model) do
  it 'belongs_to #user'
  it 'belongs_to #ad'
  it 'is unique for ad + user'
end
