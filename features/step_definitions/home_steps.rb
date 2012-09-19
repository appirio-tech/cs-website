Given /Settings exist/ do
  Settings.create access_token: SecureRandom.base64(16)
end

Given /Environment variables are set/ do
  ENV['SFDC_USERNAME'] = "cloudspork"
  ENV['SFDC_PASSWORD'] = "password"
  ENV['SFDC_REST_API_URL'] = 'http://sfdc.instance.com'
end

Given /Remote API is ready/ do
  headers = {'Authorization'=>"OAuth #{Settings.first.access_token}", 'Content-Type'=>'application/json'}

  web_pages_body = File.read(Rails.root.join("spec/data/web_pages.json"))
  leaders_body = File.read(Rails.root.join("spec/data/leaders.json"))

  @web_pages = JSON.parse(web_pages_body)
  @leaders = JSON.parse(leaders_body)

  stub_request(:get, "#{ENV['SFDC_REST_API_URL']}/webpages?fields=id,html__c&search=home").
    with(:headers => headers).
    to_return(:status => 200, :body => web_pages_body, :headers => {})

  stub_request(:get, "#{ENV['SFDC_REST_API_URL']}/leaderboard?1=1&period=all").
    with(:headers => headers).
    to_return(:status => 200, :body => leaders_body, :headers => {})

end

Then /I should see the title of featured challenge/ do
  title = @web_pages["featured_challenge_name"]
  with_scope("featured challenge") do
    page.should have_content(title)
  end
end

Then /I should see the prize of featured challenge/ do
  prize = @web_pages["featured_challenge_prize"]
  with_scope("featured challenge") do
    within(".prize") do
      page.should have_content(prize)
    end
  end
end

Then /I should see the detail link of featured challenge/ do
  challenge_id = @web_pages["featured_challenge_id"]
  with_scope("featured challenge") do
    within("a[href='/challenges/#{challenge_id}']") do
      page.should have_content("See Details")
    end
  end
end


Then /I should see the picture of featured member/ do
  picture = @web_pages["featured_member_pic"]
  with_scope("featured member") do
    page.should have_selector("img[src='#{picture}']")
  end
end

Then /I should see the name of featured member/ do
  name = @web_pages["featured_member_username"]
  with_scope("featured member") do
    page.should have_content(name)
  end
end

Then /I should see the total earned money of featured member/ do
  money = @web_pages["featured_member_money"]
  with_scope("featured member") do
    page.should have_content("$15,200")
  end
end

Then /I should see the challenge stats of featured member/ do
  active = @web_pages["featured_member_active"]
  wins = @web_pages["featured_member_wins"]
  with_scope("featured member") do
    page.should have_content("Challenge Wins: #{wins}")
    page.should have_content("Active Challenges: #{active}")
  end
end

Then /I should see member "([^"]*)" from leaderboard/ do |member|
  user_info = @leaders.detect {|l| l["username"] == member}
  with_scope("leaderboard") do
    page.should have_content(member)
    page.should have_selector("img[src='#{user_info["profile_pic__c"]}']")
  end
end

Then /I should see the link of leaderboard page/ do
  within("a[href='/leaderboard']") do
    "View leaderboards"
  end
end