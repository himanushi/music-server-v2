# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

# Rails
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# DB
gem 'mysql2', '~> 0.5'
# App server
gem 'puma', '~> 5.0'

group :development, :test do
  # Ruby debug
  gem 'debug', '~> 1.3.0'
end

# タイムゾーン
gem 'tzinfo-data', '~> 1.2021.4', platforms: %i[mingw mswin x64_mingw jruby]
