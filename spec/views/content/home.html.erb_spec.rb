require "spec_helper"

describe "content/home.html.erb" do
  let(:web_pages) { JSON.parse File.read(Rails.root.join("spec/data/web_pages.json")) }
  let(:leaders) { JSON.parse File.read(Rails.root.join("spec/data/leaders.json")) }
  before(:each) do
    web_pages.each {|k,v| assign(k.to_sym, v)}
    assign(:leaders, leaders)
  end

  it "includes the number of members" do
    assign(:members, "21231")

    render
    rendered.should match /21,231.+members/
  end
end