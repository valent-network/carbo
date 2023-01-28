# frozen_string_literal: true

module Api
  module V1
    class PresignersController < ApplicationController
      before_action :require_auth

      def create
        signer = Aws::S3::Presigner.new(client: S3_CLIENT)

        images_with_presigned_urls = params[:images].map do |image|
          key = "tmp/ad-images/user-#{current_user.id}-#{SecureRandom.uuid}.#{image[:ext]}"
          presigned_url = signer.presigned_url(
            :put_object,
            bucket: ENV['DO_SPACE_NAME'],
            key: key,
            expires_in: 300,
            content_type: image[:content_type],
          )

          image.merge(presigned_url: presigned_url, key: key)
        end

        render(json: images_with_presigned_urls)
      end
    end
  end
end
