# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  USER_FRIENDS_GRAPH = UserFriendsGraph.new # standard:disable Lint/ConstantDefinitionInBlock
  USER_FRIENDS_GRAPH.index_users
end
