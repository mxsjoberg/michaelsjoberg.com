source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'
# ruby '2.4.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.0'
# gem 'rails', '~> 5.2.1'
# gem 'rails', '~> 6.1.3'
# Use Puma as the app server
#gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.2'
# gem 'uglifier', '>= 1.3.0'
# gem 'mini_racer', platforms: :ruby
gem 'httparty'
# gem 'net-smtp'

# jQuery
gem 'jquery-rails'
# Bootstrap
gem 'bootstrap', '~> 4.1.3'
# gem 'bootstrap', '>= 4.3.1'

# Twitter
#gem 'twitter'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# github markdown reader
#gem 'github-markup', '~> 3.0.4'
# gem 'redcarpet'
gem 'commonmarker'

# github security notifications
gem "actionview", ">= 5.2.4.4"
gem 'nokogiri', '>= 1.10.8'
gem 'rack', '>= 2.2.3'
gem 'puma', '>= 4.3.5'
gem 'loofah', '>= 2.3.1'
gem 'rubyzip', '>= 1.3.0'
gem "activesupport", ">= 5.2.4.3"
gem "activestorage", ">= 5.2.4.3"
gem "actionpack", ">= 5.2.4.3"
gem "websocket-extensions", ">= 0.1.5"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
