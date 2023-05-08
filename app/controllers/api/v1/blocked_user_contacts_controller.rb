# frozen_string_literal: true

module Api
  module V1
    class BlockedUserContactsController < ApplicationController
      before_action :require_auth

      def update
        user_contact = current_user.user_contacts.find(params[:id])
        blocked_phone_number = current_user.user_blocked_phone_numbers.where(phone_number_id: user_contact.phone_number_id).first_or_initialize
        blocked_phone_number.new_record? ? blocked_phone_number.save : blocked_phone_number.destroy
        render(json: {blocked: blocked_phone_number.persisted?})
      end
    end
  end
end
