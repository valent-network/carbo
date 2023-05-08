# frozen_string_literal: true

class AddSomeForeignKeys < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key(:ad_descriptions, :ads, on_delete: :cascade)
    add_foreign_key(:ad_prices, :ads, on_delete: :cascade)
    add_foreign_key(:ad_image_links_sets, :ads, on_delete: :cascade)
    add_foreign_key(:ad_options, :ads, on_delete: :cascade)
    add_foreign_key(:ad_options, :ad_option_types, on_delete: :cascade)
    add_foreign_key(:ad_options, :ad_option_values, on_delete: :cascade)
    add_foreign_key(:chat_rooms, :ads, on_delete: :cascade)
    add_foreign_key(:chat_rooms, :users, on_delete: :cascade)
    add_foreign_key(:chat_room_users, :chat_rooms, on_delete: :cascade)
    add_foreign_key(:chat_room_users, :users, on_delete: :cascade)
    add_foreign_key(:cities, :regions, on_delete: :cascade)
    add_foreign_key(:demo_phone_numbers, :phone_numbers, on_delete: :cascade)
    add_foreign_key(:messages, :users, on_delete: :cascade)
    add_foreign_key(:messages, :chat_rooms, on_delete: :cascade)
    add_foreign_key(:seller_names, :ads, on_delete: :cascade)
    add_foreign_key(:verification_requests, :phone_numbers, on_delete: :cascade)
  end
end
