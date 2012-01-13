Feature: message boards
  As an admin
  I can create and remove message boards

  Scenario: create board
    Given a space "co.up"
      And I am signed in as the admin of "co.up"
    When I add a message board "Jobs"
    Then "co.up" should have a "Jobs" board
