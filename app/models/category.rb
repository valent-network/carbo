# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :ad_option_types
end
