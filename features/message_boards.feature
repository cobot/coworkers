Feature: message boards
  As a member
  I can post and see messages


Scenario: post to message board as member
  Given a space "co.up"
    And on cobot I'm a member of the space "co.up" with the name "Joe Doe"
    And "co.up" has a "Jobs" board
  When I sign in
    And I post a message "looking for rails gig" on the "Jobs" board
  Then the "Jobs" board should have a message "looking for rails gig" by "Joe Doe"

Scenario: post to message board as admin
  Given a space "co.up"
    And on cobot I'm an admin of the space "co.up" with the name "Joe Doe"
    And "co.up" has a "Jobs" board
  When I sign in
    And I post a message "looking for rails gig" on the "Jobs" board
  Then the "Jobs" board should have a message "looking for rails gig" by "Joe Doe"

Scenario: edit message
  Given a space "co.up"
    And on cobot I'm an admin of the space "co.up"
    And "co.up" has a "Jobs" board
    And the "Jobs" board has a message with the text "looking for PHP gig"
  When I sign in
    And I change the message on the "Jobs" board to "looking for rails gig"
  Then the "Jobs" board should have a message "looking for rails gig"
