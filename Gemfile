source "https://rubygems.org"

# NOTE: keep in sync with .circleci/config
ruby "2.6.5"

# Get rid of "git protocol is insecure" warnings by fetching "github: 'foo/bar'" gems with HTTPS instead.
# Can be removed after bundler 2.0.
# From: https://github.com/bundler/bundler/issues/4978#issuecomment-272248627
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "6.0.2.1"

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

  gem "annotate"
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
  gem "sassc-rails"
  gem "uglifier"
end
