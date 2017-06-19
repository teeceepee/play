# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'play'
set :repo_url, 'https://github.com/teeceepee/play.git'

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

set :rbenv_custom_path, '$HOME/.rbenv'
set :rbenv_ruby, File.read('.ruby-version').strip

set :nvm_custom_path, '$HOME/.nvm'
set :nvm_node, 'v7.9.0'
set :nvm_map_bins, fetch(:nvm_map_bins, []).push('bower', 'rake', 'bundle')
set :bower_flags, '--config.interactive=false --allow-root'

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/settings.yml')

# 'taobao' 'official'
set :yarn_registry, 'taobao'

LINKED_DIRS = %w(
  data
  log
  tmp/pids tmp/cache tmp/sockets
  vendor/assets/bower_components
  node_modules
  letsencrypt
  db/backup
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

namespace :yarn do
  desc 'Replace yarn registry'
  task :replace_registry do
    if fetch(:yarn_registry, 'taobao') == 'official'
      on release_roles(:app) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'yarn:replace_registry'
          end
        end
      end
    end
  end

  if Rake::Task.task_defined?('deploy:compile_assets')
    before 'deploy:compile_assets', 'yarn:replace_registry'
  end
end

namespace :letsencrypt do
  desc 'Generate certificates'
  task :gen_certs do
    on release_roles(:web) do
      within release_path do
        pem_file = 'letsencrypt/key_file.pem'
        unless test("[ -f #{pem_file} ]")
          with rails_env: fetch(:rails_env) do
            execute :rake, 'gen_key', '>', pem_file
          end
          # execute :openssl, 'genrsa 4096',  '>', pem_file
        end

        execute :rake, 'letsencrypt_plugin'
      end
    end
  end
end

desc 'Backup database'
task :db_backup do
  on primary(:db) do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, 'db_backup'
      end
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
