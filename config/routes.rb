Gridlook::Application.routes.draw do
  # Used for checks by deploy scripts
  get "revision" => ->(_) { [ 200, {}, [ ENV.fetch("GIT_COMMIT") ] ] }

  # post "/events" is added by Gridhook. See config/initializers/gridhook.rb.

  # NOTE: If you change anything here, also check JwtAuthentication config in application.rb
  get "/api/v1/events", to: "api#events"
  root to: "events#index"
end
