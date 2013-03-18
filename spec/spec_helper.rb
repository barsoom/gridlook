ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "capybara/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require "database_cleaner"
require "capybara/poltergeist"
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  # Can't use transaction with JS. Probably due to it using different
  # processes that don't share a transaction.
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, :js) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
