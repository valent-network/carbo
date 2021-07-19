# frozen_string_literal: true

class UploadUserContactsJob < ApplicationJob
  queue_as(:contacts)

  def perform(user_id, contacts)
    user = User.find(user_id)
    contacts = normalize_contacts!(JSON.parse(contacts))
    initial_contacts_count = user.user_contacts.count
    user_contacts_to_upsert = []

    full_phone_numbers = contacts.map { |contact| contact['phoneNumbers'] }.flatten.uniq
    return if full_phone_numbers.blank?

    PhoneNumber.insert_all(full_phone_numbers.map { |phone| { full_number: phone } }, unique_by: [:full_number])

    phone_numbers_mapping = Hash[PhoneNumber.where(full_number: full_phone_numbers).pluck(:full_number, :id)]

    contacts.each do |contact|
      contact['phoneNumbers'].select! { |phone| phone.to_s.in?(phone_numbers_mapping.keys) }
      contact['phoneNumbers'].each do |phone|
        user_contacts_to_upsert << {
          user_id: user_id,
          name: contact['name'],
          phone_number_id: phone_numbers_mapping[phone.to_s],
        }
      end
    end

    user_contacts_to_upsert.uniq! { |x| [x[:user_id], x[:phone_number_id]] }

    UserContact.upsert_all(user_contacts_to_upsert, unique_by: [:phone_number_id, :user_id]) if user_contacts_to_upsert.present?
    CreateEvent.call(:uploaded_contatcts, user: user, data: { contacts_count: full_phone_numbers.count })

    if initial_contacts_count.zero?
      wait_for_refresh
      ApplicationCable::UserChannel.broadcast_to(user, type: 'contacts')
    end
  end

  private

  def normalize_contacts!(contacts)
    contacts.each do |contact|
      contact['name'] = contact['name'].to_s.strip.gsub(/^(.{97,}?).*$/m, '\1...')
      contact['phoneNumbers'].select! do |phone|
        parsed = Phonelib.parse(phone)
        parsed.valid_for_country?(:UA) && parsed.types.include?(:mobile)
      end
      contact['phoneNumbers'].map! { |phone| Phonelib.parse(phone).national.to_s.gsub(/\s/, '').to_i.to_s }
    end
  end

  def wait_for_refresh
    iterations = 0
    init_time = Time.zone.now
    loop do
      ads_last_refreshed_at = REDIS.get('server.effective_ads.last_refreshed_at')
      contacts_last_refreshed_at = REDIS.get('server.effective_user_contacts.last_refreshed_at')

      break if ads_last_refreshed_at.present? && contacts_last_refreshed_at.present? && Time.zone.parse(ads_last_refreshed_at).after?(init_time) && Time.zone.parse(contacts_last_refreshed_at).after?(init_time)

      iterations += 1
      break if iterations == 10
      Rails.logger.warn("[UploadUserContactsJob][InitialContactsZero][Waiting][#{iterations}]")
      sleep(1)
    end
  end
end
