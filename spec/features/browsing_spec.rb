require "rails_helper"

describe "Browsing" do
  before do
    Event.clear_cached_mailer_actions

    ENV["HTTP_USER"] = "foobar"
    ENV["HTTP_PASSWORD"] = "secret"

    page.driver.browser.authorize("foobar", "secret")
  end

  after do
    ENV["HTTP_USER"] = nil
    ENV["HTTP_PASSWORD"] = nil
  end

  it "lists events" do
    event = create_event
    visit root_path
    expect(page).to list_event(event)
  end

  it "filters and unfilters by exact email" do
    foo = create_event("foo@example.com")
    bar = create_event("bar@example.com")

    visit root_path

    expect(page).to list_event(foo)
    expect(page).to list_event(bar)

    fill_in "Exact email", with: "bar@example.com"
    click_button "Filter"

    expect(page).not_to list_event(foo)
    expect(page).to list_event(bar)

    click_button "Remove filters"

    expect(page).to list_event(foo)
    expect(page).to list_event(bar)
  end

  it "filters and unfilters by name" do
    bounce = create_event("foo@example.com", "bounce")
    delivered = create_event("foo@example.com", "delivered")

    visit root_path

    expect(page).to list_event(bounce)
    expect(page).to list_event(delivered)

    # Clicking on event.

    click_link "delivered"

    expect(page).not_to list_event(bounce)
    expect(page).to list_event(delivered)

    # Using the filter form.

    select "bounce", from: "Event:"
    click_button "Filter"

    expect(page).to list_event(bounce)
    expect(page).not_to list_event(delivered)

    # Removing filter.

    click_button "Remove filters"

    expect(page).to list_event(bounce)
    expect(page).to list_event(delivered)
  end

  it "filters and unfilters by mailer" do
    foo_mailer = create_event("foo@example.com", "bounce", "FooMailer#baz")
    bar_mailer = create_event("foo@example.com", "delivered", "BarMailer#foo")

    visit root_path

    expect(page).to list_event(foo_mailer)
    expect(page).to list_event(bar_mailer)

    # Clicking on mailer action.

    click_link "FooMailer#baz"

    expect(page).not_to list_event(bar_mailer)
    expect(page).to list_event(foo_mailer)

    # Using the filter form.

    select "FooMailer#baz", from: "Mailer:"
    click_button "Filter"

    expect(page).to list_event(foo_mailer)
    expect(page).not_to list_event(bar_mailer)

    # Removing filter.

    click_button "Remove filters"

    expect(page).to list_event(foo_mailer)
    expect(page).to list_event(bar_mailer)
  end

  it "combines filters" do
    foo = create_event("foo@example.com", "sent")
    bar = create_event("foo@example.com", "click")
    baz = create_event("bar@example.com", "sent")

    visit root_path

    expect(page).to list_event(foo)
    expect(page).to list_event(bar)
    expect(page).to list_event(baz)

    within_event(foo) do
      click_link "foo@example.com"
    end

    within_event(foo) do
      click_link "sent"
    end

    expect(page).to list_event(foo)
    expect(page).not_to list_event(bar)
    expect(page).not_to list_event(baz)
  end

  private

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
      data: { url: "http://example.com/foo" }
    )
  end
end
