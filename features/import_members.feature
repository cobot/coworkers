@wip
Feature: Import members
  In order to advertise my awesome coworkers
  As a manager
  I want to import my coworkers into the public listing
  
  Scenario: import coworkers as a manager
    Given a space "co.up"
     And on cobot I'm an admin of the space "co.up"
     And on cobot my space "co.up" has the following members:
     | login    | email             | name           |
     | thilo    | thilo@upstre.am   | Thilo Utke     |
     | matthias | matthias@gmail.de | Matthias Jakel |
    When I sign in
      And I follow "co.up"
      And I follow "Import Members"
    Then "Thilo Utke" should be listed as a member of the space "co.up"
      And "Matthias Jakel" should be listed as a member of the space "co.up"
  
  
  
