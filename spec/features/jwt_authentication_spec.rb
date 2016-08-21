require "rails_helper"

describe "JWT authenticate" do
  after do
    ENV["JWT_KEY"] = nil
  end

  let(:secret_key) { "test" * 20 }
  let(:invalid_secret_key) { "test" * 20 + "invalid "}

  it "can authenticate with JWT" do
    ENV["JWT_SESSION_TIMEOUT_IN_SECONDS"] = "600"
    ENV["JWT_KEY"] = secret_key
    ENV["JWT_PARAM_NAME"] = "token"
    ENV["JWT_PARAM_MISSING_REDIRECT_URL"] = "http://example.com/request_jwt_auth?app=gridlook"
    ENV["JWT_ALGORITHM"] = "HS512"

    # Asks for auth when missing
    visit "/"
    expect(page).to have_content("Would redirect to: http://example.com/request_jwt_auth?app=gridlook")
    expect(page).not_to have_content("Gridlook")

    # Shows you gridlook when authenticated
    token = build_token(secret: secret_key)
    visit "/?token=#{token}"
    expect(page).to have_content("Gridlook")

    # Still authenticated on next request
    visit "/"
    expect(page).to have_content("Gridlook")

    # Still valid before the timeout
    Timecop.travel 9.minutes
    visit "/"
    expect(page).to have_content("Gridlook")

    # Requires new authentication after the timeout
    Timecop.travel 1.minute
    visit "/"
    expect(page).to have_content("Would redirect to: http://example.com/request_jwt_auth?app=gridlook")

    # Invalid token shows an error
    token = build_token(secret: invalid_secret_key)

    visit "/?token=#{token}"
    expect(page.status_code).to eq(403)
  end

  def build_token(secret:)
    payload_data = { exp: Time.now.to_i + 2 }
    JWT.encode(payload_data, secret, "HS512")
  end
end
