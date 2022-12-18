# frozen_string_literal: true
class CreateIndexOnEventsForFavAndVisited < ActiveRecord::Migration[7.0]
  def up
    execute(%[CREATE INDEX index_events_on_visited_ads on events(user_id, ((data->>'ad_id')::integer), created_at DESC) where name = 'visited_ad'])
    execute(%[CREATE INDEX index_events_on_favorited_ads on events(user_id, ((data->>'ad_id')::integer), created_at DESC) where name = 'favorited_ad'])
  end

  def down
    remove_index(:events, name: :index_events_on_visited_ads)
    remove_index(:events, name: :index_events_on_favorited_ads)
  end
end
