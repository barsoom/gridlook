class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate

  def authenticate
    # authenticated using jwt_authentication gem
    return if ENV["JWT_KEY"] && session[:jwt_user_data]

    if Rails.env.development?
      # no auth in dev by default
    else
      authenticate_with_basic_auth
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
