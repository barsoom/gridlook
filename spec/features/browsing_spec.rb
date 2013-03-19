require "spec_helper"

describe "Browsing" do
  it "works" do
    visit root_path
    page.should have_content "Gridlook"
  end
end
