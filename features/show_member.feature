Feature: Show member
	As an unregistered person
	I can see a coworker's profile
	
	Scenario: show a coworker profile
		Given a space "co.up"
			And "co.up" has a member "Joe Doe" with email "joedoe@cobot.me"
		When I visit the profile page of "Joe Doe"
		Then I should see "Joe Doe"
			And I should see "General Information"