Feature: space dashboard

Scenario: see new messages and new members
  Given a space "co.up"
    And on cobot I'm a member of the space "co.up" with the name "Joe Doe"
    And "co.up" has a "Jobs" board
    And the "Jobs" board has a message with the text "looking for a Clojure gig"
  When I sign in
  Then I should see "Joe Doe"
    And I should see "looking for a Clojure gig"
