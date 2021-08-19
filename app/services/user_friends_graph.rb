# frozen_string_literal: true
class UserFriendsGraph
  BASE_GRAPH_NAME = 'UserFriends'
  REDIS_OPTIONS = {
    host: ENV.fetch('REDISGRAPH_SERVICE_HOST', 'localhost'),
    port: ENV.fetch('REDISGRAPH_SERVICE_PORT', '63790'),
  }

  attr_reader :graph

  def initialize
    unless ENV['SKIP_REDISGRAPH'].present?
      @graph = RedisGraph.new(BASE_GRAPH_NAME, REDIS_OPTIONS)
    end
  end

  def count_users
    q("MATCH (n:User) RETURN COUNT(n)")
  end

  def index_users
    q("CREATE INDEX ON :User(id)")
  end

  def create_user(user)
    q("MERGE (:User {id: #{user.id}})")
  end

  def create_users(users)
    q(users.pluck(:id).map! { |id| "MERGE (:User {id: #{id}}) RETURN 1" }.join("\nUNION\n"))
  end

  def update_friends_for(user)
    friends_ids = UserContact.friends_users_ids_for(user)

    return if friends_ids.blank?

    # TODO: Do we need it?
    # q("MATCH (me:User {id: #{user.id}})-[r:KNOWS]->(friend:User) WHERE NOT friend.id IN #{friends_ids} DELETE r")

    statements = friends_ids.map do |id|
      "MATCH (me:User {id: #{user.id}}) MATCH (friend:User {id: #{id}}) MERGE (me)-[:KNOWS]->(friend) RETURN 1"
    end
    query = statements.join("\nUNION\n")

    q(query)
  end

  def batch_update_friends_for(users)
  end

  def delete_friends_for(user)
    q("MATCH (me:User {id: #{user.id}})-[r:KNOWS]->(:User) DELETE r")
  end

  # @return [friend.id, connection.id]
  def get_friends_connections(user, hops = 1)
    q("MATCH p=(me:User)-[:KNOWS*1..#{hops}]->(connection:User) WHERE me.id = #{user.id} RETURN DISTINCT nodes(p)[1].id, nodes(p)[length(p)].id")
  end

  def known_users_for(user, hops = 1)
    q("MATCH (me:User {id: #{user.id}}) CALL algo.BFS(me, #{hops}, 'KNOWS') YIELD nodes RETURN [node in nodes | node.id]")
  end

  private

  def q(query_string)
    return Rails.logger.warn('[UserFriendsGraph] OFF') unless graph

    t1 = Time.now.to_f
    debug(query_string)
    result = graph.query(query_string)
    t2 = (Time.now.to_f - t1) * 1000
    debug("[#{t2.round} ms] #{result.resultset}")

    result
  end

  def explain(query)
    return Rails.logger.warn('[UserFriendsGraph] OFF') unless graph

    graph.connection.call("GRAPH.PROFILE", BASE_GRAPH_NAME, query)
  end

  def debug(message)
    Rails.logger.info(ActiveSupport::LogSubscriber.new.send(:color, message, :red))
  end
end
