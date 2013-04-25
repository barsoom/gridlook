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

  it "lets you filter and unfilter by name" do
    foo = create_event("foo@example.com", "sent")
    bar = create_event("foo@example.com", "click")

    visit root_path

    page.should list_event(foo)
    page.should list_event(bar)

    click_link "click"

    page.should_not list_event(foo)
    page.should list_event(bar)

    click_button "Remove filter"

    page.should list_event(foo)
    page.should list_event(bar)
  end

  it "lets you combine filters" do
    foo = create_event("foo@example.com", "sent")
    bar = create_event("foo@example.com", "click")
    baz = create_event("bar@example.com", "sent")

    visit root_path

    page.should list_event(foo)
    page.should list_event(bar)
    page.should list_event(baz)

    within_event(foo) do
      click_link "foo@example.com"
    end

    within_event(foo) do
      click_link "sent"
    end

    page.should list_event(foo)
    page.should_not list_event(bar)
    page.should_not list_event(baz)
  end

  def within_event(event, &block)
    within("#event_#{event.id}", &block)
  end

  def list_event(event)
    have_selector("#event_#{event.id}")
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
