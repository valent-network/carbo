# frozen_string_literal: true
class CreateUniqueIndexesForUniqueEvents < ActiveRecord::Migration[6.1]
  def change
    add_index(:events, :user_id, unique: true, where: "name = 'sign_up'", name: 'uniq_sign_up_index')
    add_index(:events, :user_id, unique: true, where: "name = 'set_referrer'", name: 'uniq_set_referrer_index')
  end
end
