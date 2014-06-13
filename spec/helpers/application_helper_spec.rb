require "rails_helper"

describe ApplicationHelper do
  describe "#inspect_value" do
    def h(x)
      Rack::Utils.escape_html(x)
    end

    it "shows an array in paragraphs" do
      expect(inspect_value(["foo", "bar"])).to eq("<p>foo</p><p>bar</p>")
    end

    it "shows a hash value by value" do
      actual = inspect_value({ foo: "1", bar: ["2"] })
      expect(actual).to eq('<p>foo = 1</p>'+
                       '<p>bar = [&quot;2&quot;]</p>')
    end

    it "inspects scalars" do
      expect(inspect_value(1)).to eq("1")
    end
  end

  describe "#filtered?" do
    it "is true if the params include :email" do
      expect(filtered?(email: "yo")).to be_truthy
    end

    it "is true if the params include :name" do
      expect(filtered?(name: "yo")).to be_truthy
    end

    it "is true if the params include :mailer_action" do
      expect(filtered?(mailer_action: "yo")).to be_truthy
    end

    it "is false otherwise" do
      expect(filtered?(foo: "yo")).to be_falsey
    end
  end
end
