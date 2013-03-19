require "spec_helper"

describe "Browsing" do
  it "lists events" do
    create_event
    visit root_path
    page.should have_content "Gridlook"
    page.should have_content "foo@example.com"
    page.should have_content "sent"
  end

  def create_event
    Event.create!(
      email: "foo@example.com",
      name: "sent",
      happened_at: Time.now,
      arguments: { hello: "there" },
      category: [ "one", "two" ],
      data: { url: "http://example.com/foo" }
    )
  end
end
