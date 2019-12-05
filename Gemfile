source 'https://rubygems.org'

# http://bundler.io/git.html
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'newrelic_rpm', '5.3.0.346' # https://github.com/newrelic/rpm
gem 'carrierwave-aliyun', '0.9.0' # https://github.com/huacnlee/carrierwave-aliyun
gem 'enumerize', '2.1.2' # https://github.com/brainspec/enumerize
gem 'active_model_serializers', '0.10.6'  # https://github.com/rails-api/active_model_serializers
gem 'letsencrypt_plugin', '0.0.10'  # https://github.com/lgromanowski/letsencrypt-plugin
gem 'webpacker', '>= 4.0.x'  # https://github.com/rails/webpacker
gem 'bindata', '2.3.5' # https://github.com/dmendel/bindata
gem 'kaminari', '1.0.1' # https://github.com/kaminari/kaminari
gem 'font-awesome-sass', '4.7.0'  # https://github.com/FortAwesome/font-awesome-sass
gem 'i18n-js', '3.0.0.rc15'  # https://github.com/fnando/i18n-js
gem 'faye-websocket', '0.10.5'  # https://github.com/faye/faye-websocket-ruby
gem 'redis-activesupport', '5.0.1'  # https://github.com/redis-store/redis-activesupport
gem 'whenever', '0.9.7', require: false  # https://github.com/javan/whenever
gem 'bcrypt', '3.1.10'  # https://github.com/codahale/bcrypt-ruby
gem 'slack-notifier', '1.5.1'  # https://github.com/stevenosloan/slack-notifier
gem 'settingslogic', '2.0.9'  # https://github.com/settingslogic/settingslogic
gem 'exception_notification', '4.2.1'  # https://github.com/smartinez87/exception_notification
gem 'sidekiq', '~> 5.1.3'  # https://github.com/mperham/sidekiq
gem 'hiredis', '0.6.1'  # https://github.com/redis/hiredis-rb
gem 'redis', '~> 4.0.1', require: ['redis', 'redis/connection/hiredis']  # https://github.com/redis/redis-rb
gem 'nokogiri', '1.8.1'  # https://github.com/sparklemotion/nokogiri
gem 'http', '~> 2.0.1'  # https://github.com/httprb/http
gem 'pg', '~> 0.18.4'  # https://github.com/ged/ruby-pg
gem 'simple_form', '~> 3.5.0'  # https://github.com/plataformatec/simple_form
gem 'sprockets-es6', '~> 0.9.0'  # https://github.com/TannerRogalsky/sprockets-es6
gem 'carrierwave', '~> 0.10.0'  # https://github.com/carrierwaveuploader/carrierwave
gem 'rouge', '~> 1.10.1'  # https://github.com/jneen/rouge
gem 'slim-rails', '~> 3.1.0'  # https://github.com/slim-template/slim-rails
gem 'awesome_print', '~> 1.6.1'  # https://github.com/michaeldv/awesome_print

group :development, :test do
  gem 'elasticsearch-model', '0.1.9'  # https://github.com/elastic/elasticsearch-rails

  gem 'capistrano', '3.6.1'  # https://github.com/capistrano/capistrano
  gem 'capistrano-rbenv', '2.0.4'  # https://github.com/capistrano/rbenv
  gem 'capistrano-bundler', '1.1.4'  # https://github.com/capistrano/bundler
  gem 'capistrano-rails', '1.1.6'  # https://github.com/capistrano/rails
  gem 'capistrano3-puma', '1.2.1'  # https://github.com/seuros/capistrano-puma
  gem 'capistrano-bower', '1.1.0'  # https://github.com/platanus/capistrano-bower
  gem 'capistrano-rails-db', '0.0.2'  # https://github.com/kentaroi/capistrano-rails-db

  gem 'pry-rails', '~> 0.3.4'  # https://github.com/rweng/pry-rails
  gem 'factory_girl_rails', '~> 4.6.0'  # https://github.com/thoughtbot/factory_girl_rails
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13.0'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
