# frozen_string_literal: true
class AdImage < ApplicationRecord
  mount_base64_uploader :attachment, AdImageUploader
  belongs_to :ad
  validates :attachment, presence: true
end
