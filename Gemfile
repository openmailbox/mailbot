source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'bootsnap',         '>= 1.1.0', require: false # Reduces boot times through caching
gem 'discordrb',        '~> 3.3',   require: false
gem 'jbuilder',         '~> 2.5'                   # For making JSON APIs
gem 'omniauth-discord', '~> 1.0'
gem 'pg',               '>= 0.18', '< 2.0'         # Use postgresql for ActiveRecord
gem 'puma',             '~> 3.11'                  # Use Puma for the app server
gem 'rails',            '~> 5.2.2'
gem 'sass-rails',       '~> 5.0'                   # Use SCSS for stylesheets
gem 'turbolinks',       '~> 5'
gem 'uglifier',         '>= 1.3.0'                 # Use Uglifier for compressing JavaScript

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails',  '~> 3.8'
  gem 'dotenv-rails', '~> 2.7'
end

group :development do
  gem 'annotate',    '~> 2.7'
  gem 'listen',      '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
