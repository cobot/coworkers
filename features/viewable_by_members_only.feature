Feature: Viewable by members only

Scenario: visitor can not see member directory
  Given a space "co.up"
    And I am signed in as the admin of "co.up"
    And "co.up" has a member "Joe Doe"
  When I change the visibility to members only
    And I sign out
    And I go to the list of members for "co.up"
  Then I should not see "Joe Doe"


