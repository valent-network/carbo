# frozen_string_literal: true
module ApplicationCable
  class UserChannel < ApplicationCable::Channel
    def subscribed
      stream_for(current_user)
    end
  end
end
