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
end
