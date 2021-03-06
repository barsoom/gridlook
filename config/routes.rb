Gridlook::Application.routes.draw do
  # Used for checks by deploy scripts
  get "revision" => ->(_) { [ 200, {}, [ ENV.fetch("GIT_COMMIT") ] ] }

  # Used to trigger an error to verify error reporting
  get "boom" => ->(_) { raise "Boom!" }

  # post "/events" is added by Gridhook. See config/initializers/gridhook.rb.

  # NOTE: If you change anything here, also check JwtAuthentication config in application.rb
  get "/api/v1/events", to: "api#events"
  get "/api/v1/events/:id", to: "api#event"
  root to: "events#index"
end
