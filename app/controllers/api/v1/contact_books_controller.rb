# frozen_string_literal: true

module Api
  module V1
    class ContactBooksController < ApplicationController
      before_action :require_auth

      def update
        if params[:contacts]
          zipped_contacts = Zlib.deflate(params[:contacts].to_json).to_s
          base64_zipped_contacts = Base64.urlsafe_encode64(zipped_contacts)
          UploadUserContactsJob.perform_async(current_user.id, base64_zipped_contacts)
        end

        render(json: { message: :ok })
      end

      def destroy
        current_user.user_contacts.delete_all
        current_user.user_connections.delete_all
        USER_FRIENDS_GRAPH.delete_friends_for(current_user)
        CreateEvent.call(:deleted_contacts, user: current_user)
        render(json: [])
      end
    end
  end
end
