source 'https://rubygems.org'

gem 'denv'

gem 'rails', '~> 7.0.0'

gem 'google-cloud-bigquery'
gem 'mysql2'
gem 'pg'
gem 'presto-client'

gem 'action_args'
gem 'active_decorator'
gem 'addressable'
gem 'anbt-sql-formatter', require: 'anbt-sql-formatter/formatter'
gem 'bootsnap'
gem 'commonmarker', '< 1'  # html-pipeline v2 depends on commonmarker v0
gem 'diffy'
gem 'haml-rails'
gem 'html-pipeline', '< 3'  # html-pipeline v3 has an issue around context handling https://github.com/gjtorikian/html-pipeline/issues/402
gem 'jbuilder'
gem 'kaminari'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'puma'
gem 'revision_plate', require: 'revision_plate/rails'
gem 'rinku'
gem 'rouge'
gem 'silencer', require: 'silencer/rails/logger'
gem 'simpacker'

group :development, :test do
  gem 'byebug'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'brakeman', require: false
  gem 'foreman', require: false
  gem 'ridgepole', require: false
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'ruby-prof'
end

group :test do
  gem 'capybara'
  gem 'database_rewinder'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'simplecov', require: false
end
