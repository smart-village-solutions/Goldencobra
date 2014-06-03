Feature: Create and manage articles
  In order to make an internet article
  As an author
  I want to create and manage some articles

  Background:
    Given that basic Settings exists

  @javascript
  Scenario: Go to the articles admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title                        | url_name     | breadcrumb |
      | "10 Internet Marketing Tips" | top-10       | 10-internet |
      | "Top 10 Internet Marketers"  | top-10-tips  | top-10 |
    When I go to the admin list of articles
    And I should see "top-10" within ".index_content"
    And I should not see "Dies ist kein Artikel"

  @javascript
  Scenario: Create a new Article
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And I am on the admin list of articles
    When I click on "Erstellen"
    Then I should see "Artikel erstellen"
    When I fill in "article_title" with "Dies ist ein neuer Artikel"
    When I fill in "article_breadcrumb" with "Neuer Artikel"
    And I select "Standard Einzelseite" within "#article_article_type"
    And I press "Artikel erstellen"
    When I fill in "article_url_name" with "dies-ist-kurz"
    And I press "Artikel aktualisieren"
    Then I should see "Dies ist ein neuer Artikel" within textfield "article_title"
    And I should see "dies-ist-kurz" within textfield "article_url_name"

  @javascript
  Scenario: Visit new Article in frontend
    Given that I am not logged in
    And an article exists with the following attributes:
      |title| "Dies ist ein Test"|
      |url_name|kurzer-titel|
      |teaser| "Es war einmal..."|
      |content| "Die kleine Maus wandert um den Käse..."|
      |breadcrumb | "Test"                              |
    Then I go to the article page "kurzer-titel"
    And I should see "Dies ist ein Test" within "h1"
    And I should see "Die kleine Maus wandert um den Käse..." within "#article_content"

  @javascript
  Scenario: mark a Page as startpage
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "articles" exist:
      | title                        | startpage | id |
      | "10 Internet Marketing Tips" | false     |  2 |
      | "Startseite"                 | false     |  3 |
    When I go to the admin list of articles
    Then I click on "bearbeiten" within "tr#article_3"
    And I should see "Artikel bearbeiten" within "#page_title"
    And I should see "Diesen Artikel als Startseite einrichten"
    When I click on "Diesen Artikel als Startseite einrichten" within "#startpage_options_sidebar_section"
    Then I should see "Dieser Artikel ist nun der Startartikel"

  @javascript
  Scenario: Visit the startpage
    Given that I am not logged in
    And an startarticle exists
    Then I go to the startpage
    And I should see "Startseite" within "h1"

  @javascript
  Scenario: Change the article's title
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title           | id | url_name  |
      | "Seo Seite"     | 2  | seo-seite |
    When I go to the admin list of articles
    Then I click on "bearbeiten" within "tr#article_2"
    When I change the page's title to "Metatitle"
    And I press "Artikel aktualisieren"
    When I visit url "/seo-seite"
    Then the page title should contain "Metatitle"

  @javascript
  Scenario: Set article offline and online as an admin,I should see everything
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title           | id | url_name  | active |
      | "Seite1"        | 1  | seite1    | true   |
      | "Seite2"        | 2  | seite2    | false  |
    When I visit url "/seite1"
    Then I should see "Seite1" within "h1"
    When I visit url "/seite2"
    Then I should see "Seite2"
    Then I go to the admin list of articles
    And I click on "bearbeiten" within "tr#article_2"
    And  I check "article_active"
    And I press "Artikel aktualisieren"
    When I visit url "/seite2"
    Then I should see "Seite2" within "h1"

  @javascript
  Scenario: Set article offline and online as an user, I should see not everything
    Given that I am not logged in
    Given the following "articles" exist:
      | title           | id | url_name  | active |
      | "Seite1"        | 1  | seite1    | true   |
      | "Seite2"        | 2  | seite2    | false  |
    When I visit url "/seite1"
    Then I should see "Seite1" within "h1"
    When I visit url "/seite2"
    Then I should not see "Seite2"
    And I should see "404"
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Then I go to the admin list of articles
    And I click on "bearbeiten" within "tr#article_2"
    And  I check "article_active"
    And I press "Artikel aktualisieren"
    Given that I am not logged in
    When I visit url "/seite2"
    Then I should see "Seite2" within "h1"

  @javascript
  Scenario: Set article offline and online as an user, I should see not everything
    Given that I am not logged in
    Given the following "articles" exist:
      | title           | id | url_name  | active |
      | "Seite1"        | 1  | seite1    | true   |
      | "Seite2"        | 2  | seite2    | false  |
    When I visit url "/seite1"
    Then I should see "Seite1" within "h1"
    When I visit url "/seite2"
    Then I should not see "Seite2"
    And I should see "404"

  @javascript
  Scenario: Upload an Image and add it to an article
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title           | id | url_name  | active |
      | "Seite1"        | 1  | seite1    | true   |

  @javascript
  Scenario: Select two widgets for an article
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title     | id | url_name | active |
      | "Seite 1" |  1 | seite1   | true   |
    And the following "widgets" exist:
      | id | title   | active | tag_list | default |
      | 1 | Widget1 | true   | "sidebar" | false |
    And I go to the admin list of articles
    And I click on "bearbeiten" within "tr#article_1"
    And I check "widget_1"
    And I press "Auswahl speichern"

  @javascript
  Scenario: Set article to display Twitter Button
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title           | id | url_name    |
      | "Seo Seite"     | 2  | seo-seite |
    When I go to the admin list of articles
    Then I click on "bearbeiten" within "tr#article_2"
    Then I check "article_enable_social_sharing"
    And I press "Artikel aktualisieren"
    When I visit url "/seo-seite"
    Then the page should have content "div#twitter-sharing"
    Then the page should have content "div#google-plus-sharing"
    Then the page should have content "div#facebook-sharing-iframe"

  @javascript
  Scenario: Create a subarticle
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    Given the following "articles" exist:
      | title           | id | url_name    |
      | "Seo Seite"     | 2  | seo-seite |
    When I go to the admin list of articles
    And I click on "Neuer Unterartikel"
    Then I should see "Artikel erstellen"
    When I fill in "article_title" with "Dies ist ein Neuer Artikel"
    When I fill in "article_breadcrumb" with "Neuer Artikel"
    And I select "Standard Einzelseite" within "#article_article_type"
    And I press "Artikel erstellen"
    And I go to the admin list of articles
    Then I should see "/seo-seite/neuer-artikel" within "tr#article_3"

  @javascript
  Scenario: Follow a redirected Article
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "articles" exist:
      | title           | url_name       | external_url_redirect | active | slug          |
      | "Seo Seite"     | weiterleitung  | http://www.google.de  | true   | weiterleitung |
    When I visit url "/weiterleitung"
    Then I should see "Google"

# Nicht mehr aktuell. Früher war laut Marco der Link statisch auf der Seite.
# Derzeit wird er per JS eingebunden in ein Kopfmenü. Tests entfernt, da das
# verzögerte Einblenden Probleme macht. Sobald das Menü erneuert wurde,
# sollte ein entsprechender Test wieder reinkommen.
#
#  @javascript
#  Scenario: Look for edit_article_link in frontend
#    Given that a confirmed admin exists
#    And I am logged in as "admin@test.de" with password "secure12"
#    And an article exists with the following attributes:
#      |title| "Dies ist ein Test"|
#      |url_name|kurzer-titel|
#      |teaser| "Es war einmal..."|
#      |content| "Die kleine Maus wandert um den Käse..."|
#      |breadcrumb | "Test"                              |
#    Then I go to the article page "kurzer-titel"
#    Then show me the page
#    And I should see "Artikel bearbeiten"
#
# @javascript
# Scenario: Edit_article_link should lead to backend
#   Given that a confirmed admin exists
#   And I am logged in as "admin@test.de" with password "secure12"
#   And an article exists with the following attributes:
#     |title| "Dies ist ein Test"|
#     |url_name|kurzer-titel|
#     |teaser| "Es war einmal..."|
#     |content| "Die kleine Maus wandert um den Käse..."|
#     |breadcrumb | "Test"                              |
#   Then I go to the article page "kurzer-titel"
#   Then show me the page
#   And I click on "Artikel aktualisieren"
#   Then I should see "Artikel bearbeiten"
#   And I should see "Dies ist ein Test"

  @javascript
  Scenario: Test Permissions site is available
    Given that I am not logged in
    When I have a secured site and I log in as a visitor
    When I visit url "/seite1"
    Then I should see "Article Title"

#  Es ergibt keinen Sinn, dass sich in dem einen Schritt ein Visitor über das
#  Admin-Formular anmelden soll und erst später festgestellt werden soll,
#  das das Anmelden nicht geklappt hat.
#
#  @javascript
#  Scenario: Test Permissions site is not available
#    Given that I am not logged in
#    When I have a secured site and I log in as a visitor
#    And a restricting permission exists
#    And I visit url "/seite1"
#    Then show me the page
#    Then I should see "Diese Seite existiert nicht"

