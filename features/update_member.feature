Feature: Update member
	When I login
	my membership attributes
	should get updated
	
Scenario: I sign in and my membership name has changed
  Given a space "co.up"
    And on cobot I'm a member of the space "co.up" with login "joedoe" and name "Joe Doe"
		And I sign in
		And "Joe Doe" should be listed as a member of the space "co.up"
		And show me the page
		And I follow "Sign out"
	  And on cobot I'm a member of the space "co.up" with login "joedoe" and name "Joe Doe2"
	When I sign in
		And follow "co.up"
		And show me the page
	Then "Joe Doe2" should be listed as a member of the space "co.up"
	  And "Joe Doe" should not be listed as a member of the space "co.up"
	
	  