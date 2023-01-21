# frozen_string_literal: true
class AdImageUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/ads/#{model.ad_id}/images"
  end

  def size_range
    0..(4.megabytes)
  end

  def extension_allowlist
    %w[jpg jpeg png]
  end

  def content_type_allowlist
    [%r{image/}]
  end

  def filename
    "#{random_id}.#{file.extension}" if original_filename.present?
  end

  private

  def random_id
    @random_id ||= SecureRandom.hex
  end
end
