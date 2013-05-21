require "spec_helper"

describe ApplicationHelper do
  describe "#inspect_value" do
    def h(x)
      Rack::Utils.escape_html(x)
    end

    it "shows an array in paragraphs" do
      inspect_value(["foo", "bar"]).should == "<p>foo</p><p>bar</p>"
    end

    it "shows a hash value by value" do
      actual = inspect_value({ foo: "1", bar: ["2"] })
      actual.should == '<p>foo = 1</p>'+
                       '<p>bar = [&quot;2&quot;]</p>'
    end

    it "inspects scalars" do
      inspect_value(1).should == "1"
    end
  end

  describe "#filtered?" do
    it "is true if the params include :email" do
      filtered?(email: "yo").should be_true
    end

    it "is true if the params include :name" do
      filtered?(name: "yo").should be_true
    end

    it "is false otherwise" do
      filtered?(foo: "yo").should be_false
    end
  end
end
