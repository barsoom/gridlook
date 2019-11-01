require "rails_helper"

describe "JWT authenticate" do
  let(:secret_key) { "test" * 20 }
  let(:invalid_secret_key) { "test" * 20 + "." }

  before do
    ENV["JWT_SESSION_TIMEOUT_IN_SECONDS"] = "600"
    ENV["JWT_KEY"] = secret_key
    ENV["JWT_AUTH_MISSING_REDIRECT_URL"] = "http://example.com/request_jwt_auth?app=gridlook"
    ENV["JWT_ALGORITHM"] = "HS512"

    ENV["HTTP_USER"] = "foobar"
    ENV["HTTP_PASSWORD"] = "secret"
  end

  after do
    ENV["JWT_KEY"] = nil
    ENV["HTTP_USER"] = nil
    ENV["HTTP_PASSWORD"] = nil
  end

  it "can authenticate with JWT" do
    # Shows you gridlook at the correct URL when authenticated
    token = build_token(secret: secret_key)
    visit "/?jwt_authentication_token=#{token}"
    expect(page.status_code).to eq(200)
    expect(page).to have_content("Gridlook")
    expect(current_url).to eq("http://www.example.com/")
  end

  it "does not provide access without a valid token" do
    token = build_token(secret: invalid_secret_key)
    visit "/?jwt_authentication_token=#{token}"
    expect(page.status_code).to eq(403)
  end

  it "does not authenticate with JWT when there it is not configured" do
    ENV["JWT_KEY"] = nil

    token = build_token(secret: invalid_secret_key)
    visit "/?jwt_authentication_token=#{token}"
    expect(page.status_code).to eq(401)

    # falls back to basic auth
    page.driver.browser.authorize("foobar", "secret")
    visit "/?jwt_authentication_token=#{token}"
    expect(page.status_code).to eq(200)
    expect(page).to have_content("Gridlook")
  end

  private

  def build_token(secret:)
    payload_data = { exp: Time.now.to_i + 2, user: {} }
    JWT.encode(payload_data, secret, "HS512")
  end
end
