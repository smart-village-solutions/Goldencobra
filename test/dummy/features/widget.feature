Feature: Create and manage widgets
  In order to create a new widget
  As an admin
  I want to create and edit widgets

  Background:
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"

  Scenario: Go to the admin list of widgets
    When I go to the admin list of widgets
    Then I should see "New Widget"

  Scenario: Create a new Widget
    Given I am on the admin list of widgets
    When I click on "New Widget"
    Then I should see "New Widget"
    When I fill in "widget_title" with "Mein erstes Widget"
    And I fill in "widget_content" with "<ul><li><p>Mein Widget</p></li></p>"
    And I press "Create Widget"
    Then I should see "Mein erstes Widget" within "table"
    And I should see "Mein Widget" within "table"

  Scenario: Set articles for selected Widget
    Given I am on the admin list of widgets
    And the following "widgets" exist:
      | id |    title   |            content           |   css_name   |  active  |
      |  1 |     list   | <ul><li><p>Mein Widget</p></li></p> |  list-item   |    true  |
    When I click on "Edit" within "tr#widget_1"
    Then I should see "Widget #1" within "#page_title"
