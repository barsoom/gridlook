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

    page.should list_email(foo)
    page.should list_email(bar)

    fill_in "Exact email", with: "bar@example.com"
    click_button "Filter"

    page.should_not list_email(foo)
    page.should list_email(bar)

    click_button "Remove filter"

    page.should list_email(foo)
    page.should list_email(bar)
  end

  it "lets you filter and unfilter by name" do
    foo = create_event("foo@example.com", "sent")
    bar = create_event("foo@example.com", "click")
    visit root_path

    page.should list_name(foo)
    page.should list_name(bar)

    click_link "click"

    page.should_not list_name(foo)
    page.should list_name(bar)

    click_button "Remove filter"

    page.should list_name(foo)
    page.should list_name(bar)
  end

  def list_email(event)
    have_content(event.email)
  end

  def list_name(event)
    have_content(event.name)
  end

  def create_event(email = "foo@example.com", name = "sent")
    Event.create!(
      email: email,
      name: name,
      happened_at: Time.now,
      unique_args: { hello: "there" },
      category: [ "one", "two" ],
      data: { url: "http://example.com/foo" }
    )
  end
end
