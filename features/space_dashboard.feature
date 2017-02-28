Feature: space dashboard

Scenario: see new messages and new members
  Given a space "co.up"
    And on cobot I'm a member of the space "co.up" with the name "Joe Doe"
  When I sign in
    And I complete my profile
    And I publish my profile
    And I go to the "co.up" dashboard
  Then I should see "Joe Doe"
