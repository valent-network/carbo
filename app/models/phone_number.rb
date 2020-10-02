# frozen_string_literal: true

class PhoneNumber < ApplicationRecord
  OPERATORS = %w[67 68 96 97 98 50 66 95 99 63 93 73 91 92 94].freeze
  validates :full_number, uniqueness: true, phone: { possible: true,
                                                     allow_blank: false,
                                                     types: [:mobile],
                                                     countries: [:ua],
                                                     extensions: false }
  has_many :ads, dependent: :destroy
  has_many :user_contacts, dependent: :delete_all
  has_one :user, dependent: :destroy
  has_one :demo_phone_number, dependent: :destroy

  delegate :demo, :demo=, to: :demo_phone_number, allow_nil: true

  scope :by_full_number, ->(phone_number) { where(full_number: Phonelib.parse(phone_number).national.to_s.gsub(/\s/, '').to_i) }

  def to_s
    "+380#{full_number}"
  end

  def demo?
    demo_phone_number.present?
  end
end
