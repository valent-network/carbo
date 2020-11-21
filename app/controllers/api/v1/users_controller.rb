# frozen_string_literal: true
module Api
  module V1
    class UsersController < ApplicationController
      before_action :require_auth

      def show
        render(json: current_user)
      end

      def update
        current_user.assign_attributes(user_params) if user_params.present?
        current_device.assign_attributes(device_params) if device_params.present?

        if current_user.save && current_device.save
          render(json: current_user)
        else
          errors = [current_user.errors.to_a, current_device.errors.to_a].flatten
          render(json: { message: :error, errors: errors }, status: 422)
        end
      end

      private

      def user_params
        return {} unless params[:user]
        params[:user].permit(:name, :avatar, :remove_avatar)
      end

      def device_params
        return {} unless params[:device]
        params[:device].permit(:token, :os, :push_token, :build_version)
      end
    end
  end
end
