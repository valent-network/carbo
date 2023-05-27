# frozen_string_literal: true

module Api
  module V1
    class UserContactsController < ApplicationController
      before_action :require_auth

      def create
        normalized_phone = params[:phone].to_s.chars.last(9).join
        phone_number = PhoneNumber.where(full_number: normalized_phone).first_or_create!
        user_contact = current_user.user_contacts.where(phone_number: phone_number).first_or_initialize(name: params[:phone])

        if user_contact.save
          render(json: {message: :ok})
        else
          render(json: {errors: user_contact.errors.full_messages}, status: :unprocessable_entity)
        end
      end

      def index
        user_contacts = current_user.user_contacts.eager_load(phone_number: :user).limit(50).offset(params[:offset])
        user_contacts = user_contacts.where("user_contacts.name ILIKE :q", q: "%#{params[:query]}%") if params[:query].present?
        user_contacts = user_contacts.joins(phone_number: :user) if ActiveModel::Type::Boolean.new.cast(params[:registered_only])
        user_contacts = user_contacts.where.not(phone_number_id: current_user.phone_number_id)

        blocked_phone_numbers_query = current_user.user_blocked_phone_numbers.select(:phone_number_id).to_sql
        user_contacts = user_contacts.select("user_contacts.*, (user_contacts.phone_number_id IN (#{blocked_phone_numbers_query})) AS is_blocked")

        user_contacts = user_contacts.order("users.id, user_contacts.name")

        render(json: user_contacts)
      end
    end
  end
end
