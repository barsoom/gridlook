require "jwt"

# Support for JWT token based authentication
class JwtAuthentication
  method_object :controller

  def call
    return if authenticated?

    token = params[ENV.fetch("JWT_PARAM_NAME")]

    if token
      verify_token(token)
      store_last_authenicated_in_session
      redirect_to url_after_auth
    else
      store_url_for_later

      if Rails.env.test?
        render text: "Would redirect to: #{request_auth_url}"
      else
        redirect_to(request_auth_url)
      end
    end
  rescue JWT::DecodeError
    render text: "Could not verify your JWT token. Unauthorized.", status: 403
  end

  private

  delegate :redirect_to, :render, :params, :session, :request,
    to: :controller

  def request_auth_url
    ENV.fetch("JWT_PARAM_MISSING_REDIRECT_URL")
  end

  def verify_token(token)
    JWT.decode(token, ENV.fetch("JWT_KEY"), verify = true, algorithm: ENV.fetch("JWT_ALGORITHM"))
  end

  def authenticated?
    timeout_in_seconds = ENV.fetch("JWT_SESSION_TIMEOUT_IN_SECONDS").to_i

    last_authenticated &&
        (Time.now.to_i - last_authenticated < timeout_in_seconds)
  end

  def url_after_auth
    session.delete(:url_after_jwt_authentication) || "/"
  end

  def last_authenticated
    session[:last_authenticated_by_jwt]
  end

  def store_last_authenicated_in_session
    session[:last_authenticated_by_jwt] = Time.now.to_i
  end

  def store_url_for_later
    session[:url_after_jwt_authentication] = request.url
  end
end
