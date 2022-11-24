# frozen_string_literal: true
class DropUserContactsNameIndex < ActiveRecord::Migration[7.0]
  def up
    remove_index(:user_contacts, :name)
  end

  def down
    add_index(:user_contacts, :name, using: :gist, opclass: { title: :gist_trgm_ops })
  end
end
