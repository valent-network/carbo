# frozen_string_literal: true
class UserConnection < ApplicationRecord
  FRIENDS_HOPS = 6

  belongs_to :user
  belongs_to :connection, class_name: 'User'
  belongs_to :friend, class_name: 'User'
  has_many :user_contacts, through: :connection
end
