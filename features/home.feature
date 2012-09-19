Feature: Shows a home page.

  In order to see how awesome cloudspork is
  As an user
  I want to see some valuable information from the home page

Background:
  Given Settings exist
  And  Environment variables are set
  And Remote API is ready

Scenario: shows total stats of cloudspork
  Given I am on the home page
  Then I should see "50,080 members"
  Then I should see "19 open challenges"
  Then I should see "408 challenges won"
  Then I should see "18,000 up for grabs now"
  Then I should see "2646 entries submitted"
  Then I should see "$678,615 pending and paid"

Scenario: shows a featured challenge.
  Given I am on the home page
  Then I should see the title of featured challenge.
  Then I should see the prize of featured challenge.
  Then I should see the detail link of featured challenge.

Scenario: shows a featured member.
  Given I am on the home page
  Then I should see the picture of featured member.
  Then I should see the name of featured member.
  Then I should see the total earned money of featured member.
  Then I should see the challenge stats of featured member.

Scenario: shows leader boards.
  Given I am on the home page
  Then I should see member "robertojrojas" from leaderboard.
  Then I should see member "Nattrass" from leaderboard.
  Then I should see member "Kenji776" from leaderboard.
  Then I should see the link of leaderboard page.


