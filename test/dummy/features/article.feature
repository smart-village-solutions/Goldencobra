Feature: Create and manage articles
  In order to make an internet article
  As an author
  I want to create and manage some articles

  Scenario: Go to the articles admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title                        | url_name     |
      | "10 Internet Marketing Tips" | top-10       |
      | "Top 10 Internet Marketers"  | top-10-tips  |
    When I go to the admin list of articles
    Then I should see "10 Internet Marketing Tips"
    And I should see "Top 10 Internet Marketers" within ".index_content"
    And I should not see "Dies ist kein Artikel"

  Scenario: Create a new Article
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And I am on the admin list of articles
    When I click on "New Article"
    Then I should see "New Article"
    When I fill in "article_title" with "Dies ist ein Neuer Artikel"
    And I fill in "article_url_name" with "dies-ist-kurz"
    And I press "Create Article"
    # Then I should see "Dies ist ein Neuer Artikel" -- Tests derzeit nicht möglich. Es fehlt ein Step um Inhalte von Inputs zu testen
    # And I should see "dies-ist-kurz"
    
  Scenario: Visit new Article in frontend
    Given that I am not logged in
    And an article exists with the following attributes:
      |title| "Dies ist ein Test"|
      |url_name|kurzer-titel|
      |teaser| "Es war einmal..."|
      |content| "Die kleine Maus wandert um den Käse..."|
    Then I go to the article page "kurzer-titel"
    And I should see "Dies ist ein Test" within "h1"
    And I should see "Die kleine Maus wandert um den Käse..." within "#article_content"

  Scenario: mark a Page as startpage
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "articles" exist:
      | title                        | startpage | id |
      | "10 Internet Marketing Tips" | false     |  2 |
      | "Startseite"                 | false     |  3 |
    When I go to the admin list of articles  
    Then I click on "Edit" within "tr#article_3"
    And I should see "Edit Article" within "#page_title"
    And I should see "Make this article Startpage"
    When I click on "Make this article Startpage" within "#startpage_options_sidebar_section"
    Then I should see "This Article is the Startpage!"

  Scenario: Visit the startpage 
    Given that I am not logged in
    And an startarticle exists
    Then I go to the startpage
    And I should see "Startseite" within "h1"
    
  @javascript  
  Scenario: Set metadescription for an article
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title           | id | url_name    |
      | "Seo Seite"     | 2  | seo-seite |
    When I go to the admin list of articles
    Then I click on "Edit" within "tr#article_2"
    And I click on "Add New Metatag" within "div.has_many.metatags"
    Then I should see "Name" within "div.has_many.metatags"
    And I select "Title Tag" within "select.metatag_names"
    And I fill in "Metatitle" within "input.metatag_values"
    And I press "Update Article"
    When I visit url "/seo-seite"
    Then I should see "Metatitle"
    
  @javascript
  Scenario: Set article offline and online
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title           | id | url_name  | active |
      | "Seite1"        | 1  | seite1    | true   |
      | "Seite2"        | 2  | seite2    | false  |
    When I visit url "/seite1"
    Then I should see "Seite1" within "h1"
    When I visit url "/seite2"
    Then I should not see "Seite2"
    And I should see "404"
    Then I go to the admin list of articles
    And I click on "Edit" within "tr#article_2"
    And  I check "article_active"
    And I press "Update Article"
    When I visit url "/seite2"
    Then I should see "Seite2" within "h1"
    
  @javascript
  Scenario: Upload an Image and add it to an article
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title           | id | url_name  | active |
      | "Seite1"        | 1  | seite1    | true   |

  Scenario: Select two widgets for an article
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title     | id | url_name | active |
      | "Seite 1" |  1 | seite1   | true   |
    And the following "widgets" exist:
      | id | title   | active |
      | 1 | Widget1 | true   |
    And I go to the admin list of articles
    And I click on "Edit" within "tr#article_1"
    And I check "widget_1"
    And I press "Save Widgets"

