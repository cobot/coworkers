Feature: message boards
  As a member
  I can post and see messages


Scenario: post to message board as member
  Given a space "co.up"
    And on cobot I'm a member of the space "co.up" with the name "Joe Doe"
    And "co.up" has a "Jobs" board
  When I sign in
    And I post a message "looking for rails gig" on the "Jobs" board
  Then the "Jobs" board should have a message "looking for rails gig"

