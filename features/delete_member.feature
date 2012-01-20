Feature: Delete members

Scenario: I'm an admin and delete a member
  Given a space "co.up"
     And "co.up" has a member "Jane Doe" with email "janedoe@cobot.me"
     And on cobot I'm an admin of the space "co.up"
  When I sign in
     And "Jane Doe" should be listed as a member of the space "co.up"
     And I follow "Members"
     And I follow "remove"
  Then I should see "The member was removed."

