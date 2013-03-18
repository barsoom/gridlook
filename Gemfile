source 'https://rubygems.org'
ruby '1.9.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.beta1'

gem 'gridhook'
gem 'slim'
gem 'kaminari'
gem 'ember-rails'

group :development do
  gem 'sqlite3'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'konacha'
  gem 'konacha-chai-matchers'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'slim'
  gem 'handlebars_assets'
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# Use unicorn as the app server
# gem 'unicorn'
