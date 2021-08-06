# frozen_string_literal: true

module Api
  module V1
    class ContactBooksController < ApplicationController
      before_action :require_auth

      def update
        UploadUserContactsJob.perform_async(current_user.id, params[:contacts].to_json)
        render(json: { message: :ok })
      end

      def destroy
        current_user.user_contacts.delete_all
        CreateEvent.call(:deleted_contacts, user: current_user)
        render(json: [])
      end
    end
  end
end
