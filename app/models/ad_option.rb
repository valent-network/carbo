# frozen_string_literal: true
class AdOption < ApplicationRecord
  self.primary_key = 'id'
  belongs_to :ad
  belongs_to :ad_option_type
  belongs_to :ad_option_value

  validates :ad_id, uniqueness: { scope: [:ad_option_type] }
end
