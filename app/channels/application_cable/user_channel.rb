# frozen_string_literal: true
module ApplicationCable
  class UserChannel < ApplicationChannel
    def subscribed
      stream_for(current_user)
    end
  end
end
