source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'rack-cors', :require => 'rack/cors'

gem "doorkeeper"

# gem "provider", git: "git@github.com:cloudspace/provider_engine.git"
gem "provider", path: "engines/provider_engine"


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem "aws-sdk"
gem "devise"
gem "cancan"
gem "rolify"
gem "omniauth"
gem "omniauth-facebook"
gem "haml"
gem "paperclip"
group :test do
  gem "rspec"
  gem "rspec-rails"
  gem "shoulda"
  gem "database_cleaner"
  gem "factory_girl"
end

group :doc do
  gem "yard"
  gem "yard-activerecord"
  gem "redcarpet"
  gem "github-markup"
end

group :development do
  gem "pry-debugger"
  gem "pry-rails"
  gem "debugger"
end

group :development do
  gem "rails_best_practices"
  gem "rubocop"
  gem "metric_fu"
end

group :development do
  gem "guard-bundler"
  gem "guard-spring"
  gem "guard-rails"
  gem "guard-rspec"
end

group :production do
  gem "unicorn"
end
