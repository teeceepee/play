# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'docker_tag_tree'
set :repo_url, 'https://github.com/teeceepee/docker_tag_tree.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :nvm_type, :user
set :nvm_node, 'v5.10.1'
set :nvm_map_bins, fetch(:nvm_map_bins, []).push('bower', 'rake', 'bundle')
set :bower_flags, '--config.interactive=false --allow-root'

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/settings.yml')

LINKED_DIRS = %w(
  data
  log
  tmp/pids tmp/cache tmp/sockets
  vendor/assets/bower_components
)
set :linked_dirs, fetch(:linked_dirs, []).push(*LINKED_DIRS)


namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

desc 'Report Uptimes'
task :uptime do
  on roles(:all) do |host|
    info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
  end
end

desc 'Echo $PATH'
task :echo_path do
  on roles(:all) do |host|
    execute :echo, '$PATH'
  end
end
