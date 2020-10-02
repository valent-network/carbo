# frozen_string_literal: true
class DemoContactsPopulatorJob < ApplicationJob
  queue_as :default

  def perform
    phone_numbers = User.distinct(:phone_number_id).pluck(:phone_number_id).map { |id| { phone_number_id: id, name: "Name-#{id}" } }
    User.joins(phone_number: :demo_phone_number).each do |user|
      user.user_contacts.destroy_all
      user.user_contacts.create(phone_numbers)
    end
  end
end
