Feature: Custom questions
  In order to tailor the app to my type of coworking space
  As a space admin
  I want to add custom questions

  Scenario: add a question
    Given on cobot I'm an admin of the space "co.up"
    When I sign in
      And I add the question "What can you contribute?" to "co.up"
    Given on cobot I'm a member of the space "co.up" with the name "Joe Doe"
    When I sign in
      And I answer the question with "I can cook"
    Then the question "What can you contribute?" with the answer "I can cook" should be listed on "Joe Doe"'s profile