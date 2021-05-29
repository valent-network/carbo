# frozen_string_literal: true

class UploadUserContactsJob < ApplicationJob
  queue_as :contacts

  def perform(user_id, contacts)
    user = User.find(user_id)
    contacts = normalize_contacts!(JSON.parse(contacts))
    initial_contacts_count = user.user_contacts.count
    user_contacts_to_create = []

    full_phone_numbers = contacts.map { |contact| contact['phoneNumbers'] }.flatten.uniq
    phone_numbers_ids_hash = process_phone_numbers(full_phone_numbers)

    contacts.each do |contact|
      contact['phoneNumbers'].reject! { |phone| !phone.to_s.in?(phone_numbers_ids_hash.keys) }
      contact['phoneNumbers'].each do |phone|
        user_contacts_to_create << {
          user_id: user_id,
          name: contact['name'],
          phone_number_id: phone_numbers_ids_hash[phone.to_s],
        }
      end
    end

    UserContact.insert_all(user_contacts_to_create) if user_contacts_to_create.present?

    if initial_contacts_count.zero?
      EffectiveAdsRefreshMaterializedView.perform_now
      EffectiveUserContactsRefreshMaterializedView.perform_now
      ApplicationCable::UserChannel.broadcast_to(user, type: 'contacts')
    else
      EffectiveAdsRefreshMaterializedView.perform_later
      EffectiveUserContactsRefreshMaterializedView.perform_later
    end
  end

  private

  def normalize_contacts!(contacts)
    contacts.each do |contact|
      contact['name'] = contact['name'].to_s.strip.gsub(/^(.{97,}?).*$/m, '\1...')
      contact['phoneNumbers'].reject! { |phone| Phonelib.parse(phone).invalid_for_country?('UA') }
      contact['phoneNumbers'].map! { |phone| Phonelib.parse(phone).national.to_s.gsub(/\s/, '').to_i.to_s }
    end
  end

  def process_phone_numbers(full_phone_numbers)
    existing_full_phone_numbers = PhoneNumber.where(full_number: full_phone_numbers).pluck(:full_number)
    full_phone_numbers_to_create = full_phone_numbers - existing_full_phone_numbers

    full_phone_numbers_to_create.each do |phone|
      if phone.to_s.size != 9
        Airbrake.notify(phone)
      end
    end

    full_phone_numbers_to_create.reject! { |phone| phone.to_s.size != 9 }

    PhoneNumber.insert_all(full_phone_numbers_to_create.map { |phone| { full_number: phone } }) if full_phone_numbers_to_create.present?

    Hash[PhoneNumber.where(full_number: full_phone_numbers).pluck(:full_number, :id)]
  end
end
