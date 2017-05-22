# environment variables:
# ENV['PROVISION'] ENV['DB_SETUP'] ENV['TAOBAO_REGISTRY']

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
unless ENV['PROVISION']
  require 'capistrano/rbenv'
  require 'capistrano/bundler'
  require 'capistrano/rails/assets'
  require 'capistrano/rails/migrations'
  require 'capistrano/puma'
  require 'capistrano/puma/nginx'
  require 'capistrano/bower'
  require 'whenever/capistrano'
  require 'capistrano/rails/db'
end

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
