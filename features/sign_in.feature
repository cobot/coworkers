Feature: Sign in
  In order to get access to my space
  As a coworker
  I want to sign in

Scenario: sign up as member, space doesn't exist yet
  Given on cobot I'm a member of the space "co.up" with the name "Joe Doe" and email "joedoe@cobot.me"
  When I sign in
  Then "Joe Doe" should be listed as a member of the space "co.up"

Scenario: sign up as member, space already exists
  Given a space "co.up"
    And on cobot I'm a member of the space "co.up" with the name "Joe Doe" and email "joedoe@cobot.me"
  When I go to the home page
    And I follow "Sign in"
    And I fill in my profile info
  Then "Joe Doe" should be listed as a member of the space "co.up"

Scenario: sign in as member
  Given a space "co.up"
    And "co.up" has a member "Joe Doe" with email "joedoe@cobot.me"
    And on cobot I'm a member of the space "co.up" with the name "Joe Doe" and email "joedoe@cobot.me"
  When I sign in
  Then "Joe Doe" should be listed as a member of the space "co.up" once

Scenario: sign in as space admin, existing space
  Given a space "co.up"
    And "co.up" has a member "Joe Doe" with email "joedoe@cobot.me"
    And on cobot I'm an admin of the space "co.up"
  When I sign in
  Then "Joe Doe" should be listed as a member of the space "co.up"

Scenario: sign in as space admin, space doesn't exist yet
  Given on cobot I'm an admin of the space "co.up"
  When I sign in
  Then I should be on the list of members for "co.up"
