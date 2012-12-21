Feature: Delete members

Scenario: I'm an admin and delete a member
  Given a space "co.up"
     And "co.up" has a member "Jane Doe" with email "janedoe@cobot.me"
     And on cobot I'm an admin of the space "co.up"
  When I sign in
  Then "Jane Doe" should be listed as a member of the space "co.up"
  When I follow "Jane Doe"
    And I follow "Edit"
    And I follow "Remove Profile"
  Then I should see "The profile was removed."

