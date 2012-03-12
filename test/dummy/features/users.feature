Feature: Manage users
  In order to manage users 
  As an admin
  I want to see and manage some users
  
  Scenario: Go to the users admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given that "3" users exist
    When I go to the admin list of users
    Then I should see "firstname" of the last created "User"

