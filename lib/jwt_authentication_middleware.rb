class JwtAuthenticationMiddleware
  pattr_initialize :app

  def call(env)
    return app.call(env) unless ENV["JWT_KEY"]

    request = Rack::Request.new(env)
    token = read_token(request)

    return app.call(env) if authenticated?(request)

    if token
      verify_token(token)
      remember_last_authenicated_time(request)

      redirect_to_app_after_auth(request)
    else
      remember_url_before_auth(request)
      request_auth
    end
  rescue JWT::DecodeError
    respond_with_unauthorized_error
  end

  private

  def authenticated?(request)
    timeout_in_seconds = ENV.fetch("JWT_SESSION_TIMEOUT_IN_SECONDS").to_i

    last_authenticated_time = last_authenticated(request)
    last_authenticated_time &&
      (Time.now.to_i - last_authenticated_time < timeout_in_seconds)
  end

  def redirect_to_app_after_auth(request)
    [ 302, { "Location" => url_after_auth(request) }, [ "" ] ]
  end

  def request_auth
    if ENV["RACK_ENV"] == "test"
      [ 200, {}, [ "Would redirect to: #{request_auth_url}" ] ]
    else
      [ 302, { "Location" => request_auth_url }, [ "" ] ]
    end
  end

  def respond_with_unauthorized_error
    [ 403, {}, [ "Could not verify your JWT token. This means we can not give you access. Contact the sysadmin if the problem persists." ] ]
  end

  def verify_token(token)
    JWT.decode(token, ENV.fetch("JWT_KEY"), verify = true, algorithm: ENV.fetch("JWT_ALGORITHM"))
  end

  def read_token(request)
    param_name = ENV.fetch("JWT_PARAM_NAME")
    request.params[param_name]
  end

  def url_after_auth(request)
    request.session.delete(:url_after_jwt_authentication) || "/"
  end

  def last_authenticated(request)
    request.session[:jwt_last_authenticated_time]
  end

  def remember_last_authenicated_time(request)
    request.session[:jwt_last_authenticated_time] = Time.now.to_i
  end

  def remember_url_before_auth(request)
    request.session[:url_after_jwt_authentication] = request.url
  end

  def request_auth_url
    ENV.fetch("JWT_PARAM_MISSING_REDIRECT_URL")
  end
end
