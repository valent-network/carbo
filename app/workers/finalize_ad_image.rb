# frozen_string_literal: true
class FinalizeAdImage
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: true, backtrace: false

  def perform(ad_id, s3_key, position)
    t = Tempfile.new([File.basename(s3_key), File.extname(s3_key)])
    S3_CLIENT.get_object({ bucket: ENV['DO_SPACE_NAME'], key: s3_key }, target: t)

    ad_image = Ad.find(ad_id).ad_images.new(attachment: t, position: position)
    ad_image.file_ext = File.extname(s3_key)
    ad_image.save!

    ad_image
  end
end
