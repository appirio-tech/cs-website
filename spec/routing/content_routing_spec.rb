require "spec_helper"

describe "Content Routings" do
  describe "Root Path" do
    it "routes GET / to content#home" do
      { get: "/" }.should route_to(
        controller: "content",
        action: "home"
      )
    end
  end
end
