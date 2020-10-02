# frozen_string_literal: true
module Api
  module V1
    class UserContactsController < ApplicationController
      before_action :require_auth

      def index
        user_contacts = current_user.user_contacts.includes(phone_number: :user).limit(50).offset(params[:offset])
        user_contacts = user_contacts.where('user_contacts.name ILIKE :q', q: "%#{params[:query]}%") if params[:query].present?

        user_contacts = user_contacts.order('users.id, user_contacts.name')

        render(json: user_contacts)
      end
    end
  end
end
