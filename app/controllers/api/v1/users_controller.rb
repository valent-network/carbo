# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :require_auth

      def show
        select_columns = [
          "(SELECT count(*) FROM user_contacts WHERE user_id = #{current_user.id}) AS user_contacts_count",
          "(#{Message.select("COUNT(*)").unread_messages_for(current_user.id).reorder("").to_sql}) AS unread_messages_count",
          "users.*",
          "referrers_users.phone_number_id AS referrer_phone_number_id",
          "referrers_users.refcode AS referrer_refcode",
          "referrers_users.name AS referrer_name"
        ]
        u = User.select(select_columns).eager_load(:phone_number, :referrer, referrer_contacts: :phone_number).find(current_user.id)

        render(json: u, serializer: ProfileUserSerializer, current_user: current_user)
      end

      def update
        current_user.assign_attributes(user_params) if user_params.present?
        current_device.assign_attributes(device_params) if device_params.present?

        if current_user.save && current_device.save
          current_device.touch
          render(json: current_user)
        else
          errors = [current_user.errors.to_a, current_device.errors.to_a].flatten
          render(json: {message: :error, errors: errors}, status: 422)
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
            CreateEvent.call(:set_referrer, user: current_user, data: {referrer_id: referrer.id})
            CreateEvent.call(:invited_user, user: referrer, data: {user_id: current_user.id})
            current_user.update(referrer: referrer)
            render(json: current_user)
          end
        end
      end

      def approximate_stats
        user_contacts = current_user.user_contacts.joins(:friend).includes(friend: :ads).map do |uc|
          {
            phone_number: uc.phone_number.to_s,
            ads_count: uc.friend.ads.size,
            potential_reach: uc.friend.stats["potential_reach"]
          }
        end

        users_known_me = UserContact.select(:user_id).where(phone_number_id: current_user.phone_number_id).distinct
        users_known_me_friends = UserConnection.select(:connection_id).where(user_id: users_known_me).distinct

        payload = {
          know_me_count: users_known_me.count,
          user_contacts: user_contacts,
          estimated_ads: Ad.where(phone_number_id: User.select(:phone_number_id).where(id: users_known_me)).count,
          estimated_visibility: Ad.active.where(phone_number_id: UserContact.select(:phone_number_id).where(user_id: users_known_me_friends)).count
        }

        render(json: payload)
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
