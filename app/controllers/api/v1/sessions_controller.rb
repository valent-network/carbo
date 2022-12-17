# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      before_action :require_auth, only: %w[destroy]

      def create
        phone_number = PhoneNumber.includes(:demo_phone_number).by_full_number(params[:phone_number]).first_or_create

        if phone_number.persisted?
          unless phone_number.demo?
            if Phonelib.valid?(phone_number.full_number)
              SendUserVerificationJob.perform_async(phone_number.id)
            else
              return error!('PHONE_NUMBER_NOT_MOBILE')
            end
          end
          render(json: { message: :ok })
        else
          render(json: { message: :error, errors: phone_number.errors.to_hash }, status: 422)
        end
      end

      def update
        phone_number = PhoneNumber.includes(:demo_phone_number).by_full_number(params[:phone_number]).first_or_create!
        verification_request = VerificationRequest.where(phone_number: phone_number).first

        user = User.where(phone_number_id: phone_number.id).first_or_initialize
        if user.new_record?
          begin
            user.refcode = RefcodeGenerator.new.call
            user.save # TODO: bang?
            CreateEvent.call(:sign_up, user: user)
            USER_FRIENDS_GRAPH.create_user(user)
            SendSystemMessageToAdmins.new.call("New User signed up! Its now #{User.count} users in the system!")
          rescue
            retry
          end
        end

        if phone_number.demo?
          demo_code = phone_number.demo_phone_number.demo_code || DemoPhoneNumber::DEMO_CODE
          return error!('WRONG_VERIFICATION_CODE') if params[:verification_code].to_i != demo_code
        else
          return error!('MISSING_VERIFICATION_CODE') unless verification_request

          return error!('WRONG_VERIFICATION_CODE') if verification_request.verification_code != params[:verification_code].to_i
        end

        device = UserDevice.where(device_id: params[:device_id]).first_or_initialize

        User.transaction do
          device.user = user
          device.generate_access_token if device.persisted?
          device.save!
          verification_request.destroy! unless phone_number.demo?
        end

        CreateEvent.call(:sign_in, user: user, data: { os: device.os, build_version: device.build_version })

        render(json: { access_token: device.access_token })
      end

      def destroy
        params[:all] ? current_user.user_devices.destroy_all : current_device.destroy
        CreateEvent.call(:sign_out, user: current_user)
        render(json: { message: :ok })
      end
    end
  end
end
