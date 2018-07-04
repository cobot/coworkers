Feature: List members
  In order to get to know the others coworkers in my space
  As a coworker
  I want to see a list of them

  Scenario: see list of names
    Given a space "co.up"
      And "co.up" has a member "Jane Doe" with email "janedoe@cobot.me"
      And on cobot I'm a member of the space "co.up" with the name "Joe Doe" and email "joedoe@cobot.me"
    When I sign in
      And I publish my profile
    Then I should see "Joe Doe" and "Jane Doe" as members of "co.up"
