require "spec_helper"

describe "Browsing" do
  it "lists events" do
    event = create_event
    visit root_path
    page.should list_event(event)
  end

  it "filters and unfilters by exact email" do
    foo = create_event("foo@example.com")
    bar = create_event("bar@example.com")

    visit root_path

    page.should list_event(foo)
    page.should list_event(bar)

    fill_in "Exact email", with: "bar@example.com"
    click_button "Filter"

    page.should_not list_event(foo)
    page.should list_event(bar)

    click_button "Remove filters"

    page.should list_event(foo)
    page.should list_event(bar)
  end

  it "filters and unfilters by name" do
    bounce = create_event("foo@example.com", "bounce")
    delivered = create_event("foo@example.com", "delivered")

    visit root_path

    page.should list_event(bounce)
    page.should list_event(delivered)

    # Clicking on event.

    click_link "delivered"

    page.should_not list_event(bounce)
    page.should list_event(delivered)

    # Using the filter form.

    select "bounce", from: "Event:"
    click_button "Filter"

    page.should list_event(bounce)
    page.should_not list_event(delivered)

    # Removing filter.

    click_button "Remove filters"

    page.should list_event(bounce)
    page.should list_event(delivered)
  end

  it "filters and unfilters by mailer" do
    foo_mailer = create_event("foo@example.com", "bounce", "FooMailer#baz")
    bar_mailer = create_event("foo@example.com", "delivered", "BarMailer#baz")

    visit root_path

    page.should list_event(foo_mailer)
    page.should list_event(bar_mailer)

    # Clicking on event.

    click_link "FooMailer#baz"

    page.should_not list_event(bar_mailer)
    page.should list_event(foo_mailer)
  end

  it "combines filters" do
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

  def create_event(email = "foo@example.com", name = "sent", mailer = "FooMailer#baz")
    Event.create!(
      email: email,
      name: name,
      happened_at: Time.now,
      unique_args: { hello: "there" },
      mailer_action: mailer,
      category: [ mailer.split("#")[0], mailer ],
      data: { url: "http://example.com/foo" }
    )
  end
end
