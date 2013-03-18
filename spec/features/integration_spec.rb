# encoding: utf-8

require "spec_helper"

describe "Integration" do
  it "works", :js do
    visit "/"
    page.should have_content("Total events: 0")
  end
end
