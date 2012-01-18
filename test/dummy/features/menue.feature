Feature: Create and manage menuitems and navigationbars
  In order to make an navigationmenue
  As an admin
  I want to create and manage some menuitems

  Scenario: Go to the navigation admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "menues" exist:
      | title | id | parent_id |
      | "Top Navigation" | 1 | |
      | "News" | 2 | 1 |
      | "Bottom Navigation" | 3 | 1 |
    When I go to the admin list of menues
    Then I should see "Top Navigation"
    And I should see "News"
    And I should see "Bottom Navigation"
    
  Scenario: Create a new Menuitem
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And I am on the admin list of menues
    When I click on "New Menue"
    Then I should see "New Menue"
    When I fill in "menue_title" with "Newspapers"
    And I fill in "menue_target" with "www.newspapers.de"
    And I fill in "menue_css_class" with "news"
    And I press "Create Menue"
    Then I should see "Newspapers" within "table"
    And I should see "www.newspapers.de" within "table"
  
  Scenario: Create a submenue item
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "menues" exist:
      | title | id | parent_id |
      | "Top Navigation" | 1 |  |
      | "News" | 2 | 1 |
      | "Bottom Navigation" | 3 | 1 |
    And I am on the admin list of menues
    Then I should see "Menues" within "h2"
    When I click on "New Submenu" within "tr#menue_1"
    Then I should see "Top Navigation" within "#menue_parent_id"
    When I fill in "menue_title" with "Sub of Top"
    And I press "Create Menue"
    Then I should see "Sub of Top" within "table"
    When I click on "Edit Menue"
    Then I should see "Top Navigation" within "#menue_parent_id"