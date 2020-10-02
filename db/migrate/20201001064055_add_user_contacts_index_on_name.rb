# frozen_string_literal: true
class AddUserContactsIndexOnName < ActiveRecord::Migration[6.0]
  def change
    add_index(:user_contacts, :name, using: :gist, opclass: { title: :gist_trgm_ops })
  end
end
