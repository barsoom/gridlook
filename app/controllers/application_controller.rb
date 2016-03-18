class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if Rails.env.production?
    http_basic_authenticate_with name: ENV.fetch("HTTP_USER"), password: ENV.fetch("HTTP_PASSWORD")
  end
end
