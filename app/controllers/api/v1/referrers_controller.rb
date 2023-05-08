# frozen_string_literal: true

module Api
  module V1
    class ReferrersController < ApplicationController
      before_action :require_auth

      def show
        user = User.where(refcode: params[:id].to_s.upcase.strip).where.not(id: current_user.id).first

        if user
          render(json: {name: user.name, avatar: user.avatar.url, refcode: user.refcode})
        else
          render(json: {}, status: 404)
        end
      end
    end
  end
end
