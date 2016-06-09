source "https://rubygems.org"

ruby "2.3.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "4.2.6"

gem "gridhook"
gem "slim"
gem "kaminari"
gem "pg"
gem "jquery-rails"
gem "attr_extras"

group :test, :development do
  gem "rspec-rails"
  gem "capybara"
  gem "timecop"
end

group :production do
  gem "unicorn"
  gem "rails_12factor"
  gem "newrelic_rpm"
  gem "rack-cache"
  gem "dalli"
  gem "memcachier"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem "therubyracer", platforms: :ruby

  gem "uglifier"
end
