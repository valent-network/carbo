# frozen_string_literal: true
class AdOption < ApplicationRecord
  belongs_to :ad
  belongs_to :ad_option_type
  belongs_to :ad_option_value

  validates :ad, uniqueness: { scope: [:ad_option_type] }
end
