# frozen_string_literal: true
class AvatarUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/users/#{model.id}/avatars"
  end

  def size_range
    0..(2.megabytes)
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
