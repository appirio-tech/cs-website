require 'spec_helper'

describe ApplicationHelper do
  describe "title" do
    context "with page_title" do
      it "returns title with page_title" do
        @page_title = "challenges"

        title.should == "CloudSpokes Coding Challenges - challenges"
      end
    end

    context "without page_title" do
      it "returns cloudspokes title" do
        title.should == "CloudSpokes Coding Challenges"
      end
    end
  end
end
