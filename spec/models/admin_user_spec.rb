# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AdminUser) do
  describe "Devise" do
    it "#database_authenticatable"
    it "#rememberable"
    it "#validatable"
  end
end
