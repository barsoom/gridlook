source "https://rubygems.org"

ruby "2.3.2"

gem "rails", "5.0.0.1"

gem "gridhook"
gem "slim"
gem "kaminari"
gem "pg"
gem "jquery-rails"
gem "attr_extras"
gem "jwt"
gem "memoit"
gem "jwt_authentication", github: "barsoom/jwt_authentication"

group :test, :development do
  gem "rspec-rails"
  gem "capybara"
  gem "timecop"
  gem "barsoom_utils", github: "barsoom/barsoom_utils"
  gem "lolcat"
end

group :production do
  gem "unicorn"
  gem "rails_12factor"
  gem "newrelic_rpm"
  gem "rack-cache"
  gem "dalli"
  gem "memcachier"
end

# Gems used only for assets and not required in production environments by default.
group :assets do
  gem "sass-rails"
  gem "uglifier"
end
