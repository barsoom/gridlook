source "https://rubygems.org"

ruby "2.5.0"

gem "rails", "5.0.6"

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
  # Needed for barsoom_utils since it doesn't require it's depenencies on it's own.
  gem "lolcat"
end

group :production do
  # Two things to consider if we want to run Puma.
  #
  # - During deploy we’ll get timeouts (could be how we handle deploys).
  # - Sendgrid will try to resend events with a new internal send grid id, gridhook (the engine) doesn’t handle that (We already have this issue).
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
