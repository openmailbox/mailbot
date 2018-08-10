# frozen_string_literal: true
source "https://rubygems.org"

gem 'activerecord',     '~> 5.2', require: 'active_record'
gem 'pg',               '~> 0.18'
gem 'rake',             '~> 11.3', require: false
gem 'httparty',         '~> 0.14'
gem 'htmlentities',     '~> 4.3'
gem 'pry',              '~> 0.10', require: false
gem 'discordrb',        '~> 3.2'
gem 'sanitize',         '~> 4.6'
gem 'sentry-raven',     '~> 2.7'
gem 'chronic',          '~> 0.10'
gem 'utterance_parser', '~> 0.1'

group :development do
  gem 'annotate',           '~> 2.7'
  gem 'capistrano',         '~> 3.7'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-rvm',     '~> 0.1'
  gem 'guard',              '~> 2.14'
  gem 'guard-rspec',        '~> 4.7', require: false
end

group :development, :test do
  gem 'dotenv',   '~> 2.5'
  gem 'rspec',    '~> 3.5'
  gem 'timecop',  '~> 0.8'
  gem 'vcr',      '~> 3.0'
  gem 'webmock',  '~> 2.3'
  gem 'rubocop',  '~> 0.49'
end
