require "jwt"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if Rails.env.production?
    if ENV["JWT_KEY"]
      before_filter :authenticate_with_jwt_token
    else
      http_basic_authenticate_with name: ENV.fetch("HTTP_USER"), password: ENV.fetch("HTTP_PASSWORD")
    end
  end

  # Support for JWT token based authentication
  def authenticate_with_jwt_token
    # TODO: timeout this session after a while
    return if session[:user_previously_authorized]

    param_name = ENV.fetch("JWT_PARAM_NAME")

    if params[param_name]
      JWT.decode(params[param_name], ENV.fetch("JWT_KEY"), verify = true, algorithm: ENV.fetch("JWT_ALGORITHM"))
      session[:user_previously_authorized] = true
      # TODO: save current url in session for when you get redirected back
      redirect_to "/"
    else
      redirect_to ENV.fetch("JWT_PARAM_MISSING_REDIRECT_URL")
    end
  rescue JWT::DecodeError
    render text: "Could not verify your JWT token. Unauthorized.", status: 403
  end
end
