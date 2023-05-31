# frozen_string_literal: true

class UserDevice < ApplicationRecord
  validates :access_token, :device_id, uniqueness: true, presence: true
  # validates :os, inclusion: { in: [nil, '', 'android', 'ios'] }

  before_validation :generate_access_token, on: :create

  belongs_to :user

  def generate_access_token
    self.access_token = new_token
  end

  private

  def new_token
    loop do
      t = SecureRandom.hex
      break t unless UserDevice.where(access_token: t).exists?
    end
  end
end
