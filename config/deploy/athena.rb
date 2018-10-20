server '47.244.14.51', roles: %w(app web db)
set :rails_env, 'production'
set :yarn_registry, 'official'

set :nginx_server_name, 'nba.zhunjiaoyi.com'

# deprecated server
# server '106.15.187.240', roles: %w(app web db) # aliyun shanghai
