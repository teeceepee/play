# i18n-js
# depend on 'capistrano/rails/assets'
namespace :i18n do
  namespace :js do
    desc 'Export translations to JS file(s)'
    task :export do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'i18n:js:export'
          end
        end
      end
    end
  end

  if Rake::Task.task_defined?('deploy:compile_assets')
    before 'deploy:compile_assets', 'i18n:js:export'
  end
end
