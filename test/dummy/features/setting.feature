Feature: Read and manage settings
  In order to make some global configurations
  As an admin
  I want to see and manage some settings
  
  Scenario: Go to the settings admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of settings
    And I click on "New Setting"
    Then I fill in "setting_title" with "Titletag.Test"
    And I fill in "setting_value" with "ikusei GmbH"
    And I press "Create Setting"
    And I should see "titletag_test" within "table"
    And I should see "ikusei GmbH" within "table"

  Scenario: managa hirachical setting
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "settings" exist:
      | title                        | value        | id | parent_id |
      | "root"                       | "test1"      | 1  |           |
      | "master"                     | "test2"      | 2  |       1   |
    When I go to the admin list of settings
    And I click on "New Setting"
    Then I fill in "setting_title" with "titletag2"
    And I fill in "setting_value" with "ikusei GmbH2"
    And I select "master" within "#setting_parent_id"
    And I press "Create Setting"
    And I should see "titletag" within "table"
    And I should see "ikusei GmbH" within "table"
    And I should see "1/2" within "table"
  
