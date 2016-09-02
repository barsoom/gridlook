class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  def authenticate
    if Rails.env.production? && !ENV["JWT_KEY"]
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
end
