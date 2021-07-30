# frozen_string_literal: true
module Api
  module V1
    class UsersController < ApplicationController
      before_action :require_auth

      def show
        select_columns = [
          "(SELECT count(*) FROM user_contacts WHERE user_id = #{current_user.id}) AS user_contacts_count",
          "(#{Message.select('COUNT(*)').unread_messages_for(current_user.id).reorder('').to_sql}) AS unread_messages_count",
          'users.*',
          'referrers_users.phone_number_id AS referrer_phone_number_id',
          'referrers_users.refcode AS referrer_refcode',
          'referrers_users.name AS referrer_name',
        ]
        u = User.select(select_columns).eager_load(:phone_number, :referrer, referrer_contact: :phone_number).find(current_user.id)

        render(json: u, serializer: ProfileUserSerializer)
      end

      def update
        current_user.assign_attributes(user_params) if user_params.present?
        current_device.assign_attributes(device_params) if device_params.present?

        if current_user.save && current_device.save
          current_device.touch
          render(json: current_user)
        else
          errors = [current_user.errors.to_a, current_device.errors.to_a].flatten
          render(json: { message: :error, errors: errors }, status: 422)
        end
      end

      def set_referrer
        if current_user.referrer.present?
          raise
        else
          referrer = User.where(refcode: params[:refcode].to_s.strip.upcase).where.not(id: current_user.id).first
          if referrer.blank?
            raise
          else
            CreateEvent.call(:set_referrer, user: current_user, data: { referrer_id: referrer.id })
            CreateEvent.call(:invited_user, user: referrer, data: { user_id: current_user.id })
            current_user.update(referrer: referrer)
            render(json: current_user)
          end
        end
      end

      private

      def user_params
        return {} unless params[:user]
        params[:user].permit(:name, :avatar, :remove_avatar, :referrer_from_code)
      end

      def device_params
        return {} unless params[:device]
        params[:device].permit(:token, :os, :push_token, :build_version)
      end
    end
  end
end
