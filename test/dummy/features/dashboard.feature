Feature: Have a nice dashboard
  In order to properly use the admin backend
  As an author
  I want to have a nice dashboard

  Background:
    Given that basic Settings exists

  Scenario: As an author go to the dashboard and see recent articles
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"

    Given the following "articles" exist:
      | title                        | url_name           | teaser | breadcrumb  | content | updated_at          |
      | "10 Internet Marketing Tips" | top-10             | t1     | 10-internet | c1      | 2012-05-05 12:00:00 |
      | "Top 10 Internet Spam Sites" | top-10-spam-sites  | t2     | top-10-spams| c2      | 2012-05-05 11:00:00 |
      | "Top 10 Internet Marketers"  | top-10-tips        | t3     | top-10      | c3      | 2012-05-05 15:00:00 |

    Given I am on the admin dashboard
    Then I should see "Neueste Artikel"
    And I should see "Top 10 Internet Marketers"
    And I should see "Top 10 Internet Spam Sites"
    And I should see "10 Internet Marketing Tips"
