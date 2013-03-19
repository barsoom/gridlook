if defined?(Konacha)
  require "capybara/poltergeist"

  Konacha.configure do |config|
    config.driver = :poltergeist
    config.port = 3000
  end
end
