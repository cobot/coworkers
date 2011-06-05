Feature: List members
  In order to get to know the others coworkers in my space
  As a coworker
  I want to see a list of them

  Scenario: see list of names
    Given a space "co.up"
      And "co.up" has a member "Jane Doe"
      And on cobot I'm a member of the space "co.up" with the name "Joe Doe"
    When I sign in
    Then I should see "Joe Doe" and "Jane Doe" as members of "co.up"
    
  Scenario: enter and see more details
    Given on cobot I'm a member of the space "co.up" with the name "Joe Doe"
    When I sign in
      And I add my website "facebook.com" to my profile
    Then "Joe Doe" should have listed the website "facebook.com" on his "co.up" profile
