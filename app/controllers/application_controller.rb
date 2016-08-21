require "jwt_authentication"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  def authenticate
    if ENV["JWT_KEY"]
      authenticate_with_jwt_token
    elsif Rails.env.production?
      authenticate_with_basic_auth
    elsif Rails.env.development? || Rails.env.test?
      # no auth in dev or test by default
    else
      raise "No auth?"
    end
  end

  def authenticate_with_basic_auth
    authenticate_with_http_basic do |user, password|
      user == ENV.fetch("HTTP_USER") && password == ENV.fetch("HTTP_PASSWORD")
    end || request_http_basic_authentication
  end

  # Support for JWT token based authentication
  def authenticate_with_jwt_token
    JwtAuthentication.call(jwt_token, session, self)
  end

  def jwt_auth_missing
    if Rails.env.test?
      render text: "Would redirect to: #{request_auth_url}"
    else
      redirect_to(request_auth_url)
    end
  end

  def jwt_auth_successful
    redirect_to "/"
  end

  def jwt_auth_failed
    render text: "Could not verify your JWT token. Unauthorized.", status: 403
  end

  private

  def jwt_token
    params[ENV.fetch("JWT_PARAM_NAME")]
  end

  def request_auth_url
    ENV.fetch("JWT_PARAM_MISSING_REDIRECT_URL")
  end
end
