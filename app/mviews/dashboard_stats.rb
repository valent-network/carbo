# frozen_string_literal: true

class DashboardStats < ApplicationRecord
  self.primary_key = :updated_at
  include Materializable
end
