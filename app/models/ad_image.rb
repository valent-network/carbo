# frozen_string_literal: true
class AdImage < ApplicationRecord
  mount_uploader :attachment, AdImageUploader
  belongs_to :ad
  validates :attachment, presence: true
  attr_accessor :random_id, :file_ext
end
