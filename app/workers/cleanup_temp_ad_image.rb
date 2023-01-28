# frozen_string_literal: true
class CleanupTempAdImage
  UPLOAD_INTERVAL = 1.hour

  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: true, backtrace: false

  def perform
    response = S3_CLIENT.list_objects(prefix: "tmp/ad-images", bucket: ENV['DO_SPACE_NAME'])
    to_delete = response.contents.select { |obj| obj.last_modified.before?(UPLOAD_INTERVAL.ago) }
    S3_CLIENT.delete_objects(bucket: ENV['DO_SPACE_NAME'], delete: { objects: to_delete.map { |obj| { key: obj.key } } })
  end
end
