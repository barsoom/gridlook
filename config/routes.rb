Gridlook::Application.routes.draw do
  # Used for checks by deploy scripts
  get "revision" => ->(_) { [ 200, {}, [ ENV.fetch("GIT_COMMIT") ] ] }

  root to: 'events#index'
end
