Feature: Create and manage widgets
  In order to create a new widget
  As an admin
  I want to create and edit widgets

  Background:
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And that basic Settings exists

  Scenario: Go to the admin list of widgets
    When I go to the admin list of widgets
    Then I should see "Schnipsel erstellen"

  Scenario: Create a new Widget
    Given I am on the admin list of widgets
    When I click on "Schnipsel erstellen"
    Then I should see "Schnipsel erstellen"
    When I fill in "widget_title" with "Mein erstes Widget"
    And I fill in "widget_content" with "<ul><li><p>Mein Widget</p></li></p>"
    And I press "Schnipsel erstellen"
    Then I should see "Mein erstes Widget" within textfield "widget_title"
