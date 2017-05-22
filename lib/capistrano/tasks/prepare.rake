namespace :prepare do
  desc 'Create db user'
  task :create_db_user do
    on primary(fetch(:migration_role)) do
      execute 'cd /; sudo -u postgres createuser -s root'
    end
  end


  desc 'Download linked config files'
  task :download_files do
    on release_roles(:all) do
      within shared_path do
        fetch(:linked_files, []).each do |file|
          local_file = File.join('./tmp/linked_files', file)
          FileUtils.mkdir_p(File.dirname(local_file))
          download!(File.join(shared_path, file), local_file)
        end
      end
    end
  end

  desc 'Upload linked config files'
  task :upload_files do
    on release_roles(:all) do
      execute :mkdir, '-p', shared_path

      within shared_path do
        fetch(:linked_files, []).each do |file|
          local_file_path = File.join('./tmp/linked_files', file)
          if File.exist?(local_file_path)
            remote_file = File.join(shared_path, file)
            execute :mkdir, '-p', File.dirname(remote_file)
            upload!(local_file_path, remote_file)
          else
            info "File not exists: #{local_file_path}"
          end
        end
      end
    end
  end

end

if ENV['DB_SETUP']
  before 'deploy:migrate', 'deploy:db:setup'
end
