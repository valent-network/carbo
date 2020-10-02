# frozen_string_literal: true
module Api
  module V1
    class FriendlyAdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.find(params[:id])

        query = UserRootFriendsForAdQuery.new.call(current_user.id, ad.phone_number_id)
        friends = UserContact.select('DISTINCT ON (friends.id) friends.*').from("(#{query}) friends").order('friends.id, friends.idx').to_a

        payload = friends.sort_by(&:idx).map { |uc| { name: uc.name, id: uc.id, idx: uc.idx } }

        render(json: payload)
      end
    end
  end
end
