# frozen_string_literal: true
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      verified_user = UserDevice.includes(:user).where(access_token: request.params['access_token']).first&.user
      verified_user ? verified_user : reject_unauthorized_connection
    end
  end
end
