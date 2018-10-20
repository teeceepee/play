namespace :provision do
  desc 'Upload sources.list'
  task :upload_sources do
    on release_roles(:all) do
      within('/etc/apt') do
        execute :cp, 'sources.list', 'sources.list.default'
        upload!('config/deploy/templates/sources.list', '/etc/apt/sources.list')
      end
    end
  end

  # nginx-stable with ALPN support (OpenSSL 1.0.2+) for 14.04 Trusty
  # for http2
  # append `include /etc/nginx/sites-enabled/*;` in nginx.conf
  desc 'Install nginx'
  task :install_nginx do
    on release_roles(:all) do
      execute 'add-apt-repository', '--yes', 'ppa:fxr/nginx-alpn'
      execute 'apt-get', 'update'
      execute 'apt-get', 'install', '--yes', 'nginx'
    end
  end

  desc 'Install dependency packages'
  task :install_deps do
    on release_roles(:all) do
      execute 'apt-get', 'update'
      execute 'apt-get', 'install', '--yes', *fetch(:dep_packages)
    end
  end


  desc 'Upload nginx.conf'
  task :upload_nginx_conf do
    on release_roles(:all) do
      within('/etc/nginx') do
        execute :cp, 'nginx.conf', 'nginx.conf.default'
        execute :mkdir, '-p', 'sites-available', 'sites-enabled'
        upload!('config/deploy/templates/nginx/nginx.conf', '/etc/nginx/nginx.conf')
      end
    end
  end

  desc 'Install rbenv'
  task :install_rbenv do
    on release_roles(:all) do
      rbenv_path = fetch(:rbenv_custom_path)
      ruby_build_path = File.join(rbenv_path, 'plugins/ruby-build')

      if test("[ -d #{rbenv_path} ]")
        info 'rbenv has been installed, installed versions: '
        info capture("#{fetch(:rbenv_custom_path)}/bin/rbenv version")
        info ''
      else
        execute :git, 'clone', 'https://github.com/rbenv/rbenv.git', rbenv_path
      end

      if test("[ -d #{ruby_build_path} ]")
        info 'ruby-build has been installed'
      else
        execute :git, 'clone', 'https://github.com/rbenv/ruby-build.git', ruby_build_path
      end
    end
  end

  desc 'Update rbenv'
  task :update_rbenv do
    on release_roles(:all) do
      within fetch(:rbenv_custom_path) do
        execute :git, 'pull'
      end

      within File.join(fetch(:rbenv_custom_path), 'plugins/ruby-build') do
        execute :git, 'pull'
      end
    end
  end

  desc 'Install Ruby'
  task :install_ruby do
    gems = %w(bundler).join(' ')
    rbenv = "#{fetch(:rbenv_custom_path)}/bin/rbenv"

    on release_roles(:all) do
      with rbenv_version: fetch(:rbenv_ruby) do
        execute rbenv, 'install --skip-existing', fetch(:rbenv_ruby)
        execute rbenv, 'exec', 'gem install --no-document', gems
      end
    end
  end

  desc 'Install nvm'
  task :install_nvm do
    on release_roles(:all) do
      if test("[ -d #{fetch(:nvm_custom_path)} ]")
        info 'nvm has been installed.'
      else
        execute :git, 'clone', 'https://github.com/creationix/nvm.git', fetch(:nvm_custom_path)
      end

      within fetch(:nvm_custom_path) do
        execute :git, 'checkout', 'v0.33.2'
      end
    end
  end

  desc 'Install Node'
  task :install_node do
    node_pkgs = %w(yarn bower).join(' ')
    nvm_prefix = "source #{fetch(:nvm_custom_path)}/nvm.sh; nvm exec --silent #{fetch(:nvm_node)}"
    registry_option = ENV['TAOBAO_REGISTRY'] ? '--registry=https://registry.npm.taobao.org' : ''

    on release_roles(:all) do
      execute "source #{fetch(:nvm_custom_path)}/nvm.sh; nvm install #{fetch(:nvm_node)}"
      execute "#{nvm_prefix} npm install --global #{registry_option} #{node_pkgs}"
    end
  end

  # For the host in China, use taobao registry to download packages
  desc 'Upload .npmrc file'
  task :upload_npmrc do
    if ENV['TAOBAO_REGISTRY']
      on release_roles(:all) do
        upload!('config/deploy/templates/dot_files/.npmrc', '.npmrc')
      end
    end
  end

  # https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04
  namespace :swap_file do
    desc 'Add an 1G swap file'
    task :add do
      on release_roles(:all) do
        file = fetch(:swap_file_path)
        execute "fallocate -l 1G #{file}"
        execute "chmod 600 #{file}"
        execute "mkswap #{file}"
      end
    end

    desc 'Enable swap file'
    task :swapon do
      on release_roles(:all) do
        execute "swapon #{fetch(:swap_file_path)}"
      end
    end

    desc 'Disable swap file'
    task :swapoff do
      on release_roles(:all) do
        execute "swapoff #{fetch(:swap_file_path)}"
      end
    end

    desc 'Show enabled swap files'
    task :show do
      on release_roles(:all) do
        is_ub14 = capture('cat /etc/issue').match(/14/)
        option = is_ub14 ? '--summary' : '--show'
        execute "swapon #{option}"
      end
    end
  end

end

namespace :load do
  task :defaults do
    packages = %w(
      autoconf
      bison
      build-essential

      docker.io
      git
      nginx
      phantomjs
      postgresql
      redis-server
      sqlite3
    )

    lib_packages = %w(
      libffi-dev
      libgdbm-dev
      libgdbm3
      libncurses5-dev
      libpq-dev
      libreadline6-dev
      libsqlite3-dev
      libssl-dev
      libyaml-dev
      zlib1g-dev
    )

    set :dep_packages, (packages + lib_packages)

    set :swap_file_path, '/swapfile'
  end
end
