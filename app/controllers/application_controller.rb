class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate

  def authenticate
    if ENV["JWT_KEY"]
      # authenticate using jwt_authentication gem
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

  private

  # This is useful when you have parameters that doesn't bother with strong params security.
  # So use this in place of params when generating links etc.
  #
  # See https://github.com/rails/rails/issues/26289
  def safe_params
    params.except(:host, :port, :protocol).permit!
  end
  helper_method :safe_params
end
