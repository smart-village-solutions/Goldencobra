Feature: Create and manage menuitems and navigationbars
  In order to make an navigationmenue
  As an admin
  I want to create and manage some menuitems

  Background:
    Given that basic Settings exists

  Scenario: Go to the navigation admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "menues" exist:
      | title | id | parent_id |
      | Top Navigation | 1 | |
      | News | 2 | 1 |
      | Bottom Navigation | 3 | 1 |
    When I go to the admin list of menues
    Then I should see "Top Navigation"
    And I should see "News"
    And I should see "Bottom Navigation"

  Scenario: Create a new Menuitem
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And I am on the admin list of menues
    When I click on "Menü erstellen"
    Then I should see "Menü erstellen"
    When I fill in "menue_title" with "Newspapers"
    And I fill in "menue_target" with "www.newspapers.de"
    And I fill in "menue_css_class" with "news"
    And I press "Menü erstellen"
    Then I should see "Newspapers" within textfield "menue_title"
    And I should see "www.newspapers.de" within textfield "menue_target"

  Scenario: Create a submenue item
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "menues" exist:
      | title | id | parent_id |
      | Top Navigation | 1 |  |
      | News | 2 | 1 |
      | Bottom Navigation | 3 | 1 |
    And I am on the admin list of menues
    Then I should see "Menüpunkte" within "h2"
    When I click on "New Submenu" within "tr#menue_1"
    Then I should see "Top Navigation" within "#menue_parent_id"
    When I fill in "menue_title" with "Sub of Top"
    And I press "Menü erstellen"
    Then I should see "Sub of Top" within textfield "menue_title"
    And I should see "Top Navigation" within "#menue_parent_id"

  Scenario: Go to the Startpage and check the NavigationMenue with no restrictions
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "menues" exist:
      | title | id | parent_id |
      | Top Navigation | 1 |  |
      | News | 2 | 1 |
      | Secured | 3 | 1 |
    And an startarticle exists
    Then I go to the startpage
    And I should see "News"
    And I should see "Secured"

  Scenario: Go to the Startpage and check the NavigationMenue with restricted Access
    Given that a confirmed guest exists
    And I am logged in as "guest@test.de" with password "secure12"
    And the following "menues" exist:
      | title | id | parent_id |
      | Top Navigation | 1 |  |
      | News | 2 | 1 |
      | Secured | 3 | 1 |
    And a "not_read" permission on "Goldencobra::Menue" at id "3" for role "guest"
    And an startarticle exists
    Then I go to the startpage
    And I should see "News"
    And I should not see "Secured"
