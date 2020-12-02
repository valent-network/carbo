# frozen_string_literal: true
class StaticPage < ApplicationRecord
  validates :title, :slug, :body, presence: true
  validates :slug, uniqueness: true
  validates :title, :slug, length: { minimum: 1, maximum: 255 }

  def meta=(value)
    super(JSON.parse(value))
  rescue JSON::ParserError
    errors.add(:meta, 'JSON is invalid')
  end

  def meta
    self[:meta].to_json
  end
end
