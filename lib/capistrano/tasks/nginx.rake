namespace :nginx do
  desc 'Show nginx status'
  task :status do
    on roles(:web) do
      execute :service, 'nginx', 'status'
    end
  end

  desc 'Reload nginx configuration'
  task :reload do
    on roles(:web) do
      execute :service, 'nginx', 'reload'
    end
  end

  desc 'Restart nginx'
  task :restart do
    on roles(:web) do
      execute :service, 'nginx', 'restart'
    end
  end

  desc 'Stop nginx'
  task :stop do
    on roles(:web) do
      execute :service, 'nginx', 'stop'
    end
  end

  desc 'Upload site configs'
  task :upload_sites do
    on release_roles(:web) do
      within('/etc/nginx') do
        execute :cp, 'nginx.conf', 'nginx.conf.default'
        execute :mkdir, '-p', 'sites-available', 'sites-enabled'
        upload!('config/deploy/templates/nginx/sites-enabled/gif917', '/etc/nginx/sites-enabled/gif917')
      end
    end
  end
end
