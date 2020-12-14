# frozen_string_literal: true
class UserDeviceStat < ApplicationRecord
  validates :user_devices_appeared_count, presence: true, numericality: { only_integer: true }
end
