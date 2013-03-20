require "spec_helper"

describe ApplicationHelper do
  describe "#inspect_value" do
    def h(x)
      Rack::Utils.escape_html(x)
    end

    it "inspects a non-hash" do
      inspect_value([]).should == "[]"
    end

    it "shows a hash value by value" do
      actual = inspect_value({ foo: "1", bar: ["2"] })
      actual.should == '<p>foo = 1</p>'+
                       '<p>bar = [&quot;2&quot;]</p>'
    end
  end
end
