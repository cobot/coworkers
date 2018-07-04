Feature: Update member
  When I log in
  my membership attributes
  should get updated

Scenario: I sign in and my membership name has changed
  Given a space "co.up"
    And on cobot I'm a member of the space "co.up" with the name "Joe Doe"
    And I sign in
    And I publish my profile
  Then "Joe Doe" should be listed as a member of the space "co.up"
  Given on cobot I'm a member of the space "co.up" with the name "John Doe"
  When I sign in
  Then "John Doe" should be listed as a member of the space "co.up"
    And "Joe Doe" should not be listed as a member of the space "co.up"
