require "spec_helper"

describe "Browsing" do
  it "lists events" do
    create_event
    visit root_path
    page.should have_content "Gridlook"
    page.should have_content "foo@example.com"
    page.should have_content "sent"
  end

  it "lets you filter and unfilter by exact email" do
    foo = create_event("foo@example.com")
    bar = create_event("bar@example.com")
    visit root_path

    page.should list_event(foo)
    page.should list_event(bar)

    fill_in "Exact email", with: "bar@example.com"
    click_button "Filter"

    page.should_not list_event(foo)
    page.should list_event(bar)

    click_button "Remove filter"

    page.should list_event(foo)
    page.should list_event(bar)
  end

  def list_event(event)
    have_content(event.email)
  end

  def create_event(email = "foo@example.com")
    Event.create!(
      email: email,
      name: "sent",
      happened_at: Time.now,
      unique_args: { hello: "there" },
      category: [ "one", "two" ],
      data: { url: "http://example.com/foo" }
    )
  end
end
