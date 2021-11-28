# frozen_string_literal: true
class UserFriendsGraph
  BASE_GRAPH_NAME = 'UserFriends'
  REDIS_OPTIONS = {
    host: ENV.fetch('REDISGRAPH_SERVICE_HOST', 'localhost'),
    port: ENV.fetch('REDISGRAPH_SERVICE_PORT', '6379'),
    password: ENV.fetch('REDISGRAPH_SERVICE_PASSWORD', nil),
  }

  attr_reader :graph

  def initialize
    redis_options = REDIS_OPTIONS
    redis_options.delete(:password) if REDIS_OPTIONS[:password].blank?
    @graph = RedisGraph.new(BASE_GRAPH_NAME, redis_options)
  rescue Redis::CannotConnectError
    @graph = nil
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

  # @return [friend.id, connection.id, hops_count]
  def get_friends_connections(user, hops = 1)
    blocked_users_ids = user.blocked_users_ids.join(', ')

    cypher_query = <<~CYPHER_QUERY
      MATCH p=(me:User{id: #{user.id}})-[:KNOWS*1..#{hops}]->(connection:User)
      WHERE ALL(
        user IN NODES(p) WHERE (ALL(
          blocked_id IN [#{blocked_users_ids}] WHERE user.id <> blocked_id )
        )
      )
      RETURN DISTINCT NODES(p)[1].id, NODES(p)[LENGTH(p)].id, min(LENGTH(p))
    CYPHER_QUERY

    q(cypher_query)
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
    to_debug = "[#{t2.round} ms] "
    to_debug << result.resultset if Rails.env.dev?
    debug(to_debug)

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
