Feature: Sign up
  In order to get listed as a member of my space
  As a visitor
  I want to sign up

Scenario: sign up as member, space doesn't exist yet
  Given on cobot I'm a member of the space "co.up" with the name "Joe Doe"
  When I sign up
  Then "Joe Doe" should be listed as a member of the space "co.up"
