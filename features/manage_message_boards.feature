Feature: message boards
  As an admin
  I can create and remove message boards

  Background:
    Given a space "co.up"
      And I am signed in as the admin of "co.up"

  Scenario: create board
    When I add a message board "Jobs"
    Then "co.up" should have a "Jobs" board

  Scenario: remove message board
    Given "co.up" has a "Jobs" board
    When I remove the "Jobs" board
    Then "co.up" should have no "Jobs" board
