# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# The default key is just for dev.
# Production gets another key from an ENV.

if Rails.env.production?
  Gridlook::Application.config.secret_key_base = ENV["SECRET_KEY_BASE"] || raise("Missing SECRET_KEY_BASE")
else
  Gridlook::Application.config.secret_key_base = ENV["SECRET_KEY_BASE"] || "9cd6c5830609bb6254377d65666dd77df8c55a4e37a6fc2ccc1514c085c747fbc14e48aeef8a75c26d6320da0cfe04233ed0375f15684da4957a0527f53991fe"
end
