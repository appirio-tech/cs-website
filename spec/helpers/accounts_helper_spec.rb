require 'spec_helper'

describe AccountsHelper do
  describe "#build_menu" do
    it "should return html_safe string" do
      build_menu('top', 'payments').should be_html_safe
    end

    it "should fail when given invalid menu" do
      expect { build_menu('foo', 'payments') }.to raise_exception
    end
  end
end
