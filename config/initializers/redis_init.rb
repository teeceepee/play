# Redis db number distribution
# 0 => data
# 1 => Sidekiq

Redis.current = Redis.new(db: 0)

url = 'redis://localhost:6379/1'
redis_config = {
  url: url,
}

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
