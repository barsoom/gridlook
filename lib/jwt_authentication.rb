require "jwt"

# Support for JWT token based authentication
class JwtAuthentication
  method_object :token, :session, :callback

  def call
    return if authenticated?

    if token
      verify_token
      store_last_authenicated_in_session
      callback.jwt_auth_successful
    else
      callback.jwt_auth_missing
    end
  rescue JWT::DecodeError
    callback.jwt_auth_failed
  end

  private

  def verify_token
    JWT.decode(token, ENV.fetch("JWT_KEY"), verify = true, algorithm: ENV.fetch("JWT_ALGORITHM"))
  end

  def authenticated?
    timeout_in_seconds = ENV.fetch("JWT_SESSION_TIMEOUT_IN_SECONDS").to_i

    last_authenticated &&
        (Time.now.to_i - last_authenticated < timeout_in_seconds)
  end

  def store_last_authenicated_in_session
    session[:last_authenticated_by_jwt] = Time.now.to_i
  end

  def last_authenticated
    session[:last_authenticated_by_jwt]
  end
end
