# frozen_string_literal: true
class UserConnection < ApplicationRecord
  FRIENDS_HOPS = 5

  belongs_to :user
  belongs_to :connection, class_name: 'User'
  belongs_to :friend, class_name: 'User'
  has_many :user_contacts, through: :connection

  validates :user_id, uniqueness: { scope: %i[friend_id connection_id] }
  validates :user_id, :friend_id, :connection_id, presence: true
end
