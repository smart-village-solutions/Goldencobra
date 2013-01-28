Feature: Manage users
  In order to manage users
  As an admin
  I want to see and manage some users

  Background:
    Given that basic Settings exists

  Scenario: Go to the users admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given that "3" users exist
    When I go to the admin list of users
    Then I should see "firstname" of the last created "User"

  Scenario: Update user without changing/providing password
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of users
    And I click on "Edit"
    And I fill in "user_firstname" with "Alexander"
    And I press "Update User"
    Then I should see "Alexander" within textfield "user_firstname"
    When I go to the admin list of users
    And I click on "Edit"
    Then I should see "Alexander" within textfield "user_firstname"

  Scenario: Update user and change password
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of users
    And I click on "Edit"
    And I fill in "user_firstname" with "Alexander"
    And I fill in "user_password" with "secure13"
    And I fill in "user_password_confirmation" with "secure13"
    And I press "Update User"
    Then I should see "Alexander" within textfield "user_firstname"
    When I am logged in as "admin@test.de" with password "secure13"
    And I go to the admin list of users
    And I click on "Edit"
    Then I should see "Alexander" within textfield "user_firstname"

  Scenario: Update user and provide unmatching passwords
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of users
    And I click on "Edit"
    And I fill in "user_firstname" with "Alexander"
    And I fill in "user_password" with "secure13"
    And I fill in "user_password_confirmation" with "secure14"
    And I press "Update User"
    Then I should see "doesn't match confirmation"

  @javascript
  Scenario: Update a user's vita steps
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of users
    And I click on "Edit"
    And I click on "Add New Vita Step"
    And I fill in "Eintrag" with "Das ist ein Test"
    And I fill in "Bearbeiter" with "Holger"
    And I press "Update User"
    Then I should see "Das ist ein Test"
