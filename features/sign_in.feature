Feature: Sign in
  In order to get access to my space
  As a visitor
  I want to sign in

Scenario: sign up as member, space doesn't exist yet
  Given on cobot I'm a member of the space "co.up" with the name "Joe Doe"
  When I sign in
  Then "Joe Doe" should be listed as a member of the space "co.up"

Scenario: sign up, space already exists
  Given a space "co.up"
    And on cobot I'm a member of the space "co.up" with the name "Joe Doe"
  When I sign in
  Then "Joe Doe" should be listed as a member of the space "co.up"
