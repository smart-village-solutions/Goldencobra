Feature: visit pages in Frontend
  In find some informations
  As an user
  I see some pages and navigate between them

  Background:
    Given that basic Settings exists

# See ticket gc-56
#  Scenario: Visit the startpage with an Mainmenue
#    Given that I am not logged in
#    And an startarticle exists
#    And the following "menues" exist:
#      | title             | id   | parent_id | target                    | css_class  | active |
#      | Top Navigation    | 421  |           |                           | "main"     | true   |
#      | Bottom Navigation | 422  |           |                           | "bottom"   | true   |
#      | News              | 423  | 421       | "/news"                   | "news"     | true   |
#      | Sub-News          | 426  | 423       | "/subnews"                | "subnews"  | true   |
#      | Sub-News2         | 427  | 423       | "/subnews2"               | "subnews"  | true   |
#      | Sub-Sub-News2     | 428  | 427       | "/subnews6"               | "subnews"  | true   |
#      | Contact           | 424  | 421       | "/contact"                |            | true   |
#      | Blog1             | 425  | 422       | "/blog"                   |            | true   |
#      | Blog2             | 429  | 425       | "/blog/blog2"             |            | true   |
#      | Blog2-2           | 4213 | 425       | "/blog/blog22"            |            | true   |
#      | Blog3             | 4210 | 429       | "/blog/blog2/blog3"       |            | true   |
#      | Blog4             | 4211 | 4210      | "/blog/blog2/blog3/blog4" | "selected" | true   |
#      | Blog5             | 4212 | 4210      | "/blog/blog2/blog3/blog5" |            | true   |
#      | Invisible         | 4214 | 421       | "/invisible"              |            | false  |
#    And the following "articles" exist:
#      | title         | content                          | id  | url_name | parent_id | article_type | breadcrumb  |
#      | "Newspage"    | "Dies ist eine Nachrichtenseite" | 422 | news     |           | Default Show | Newspage    |
#      | "ContactPage" | "Dies ist eine Kontaktseite"     | 423 | contact  |           | Default Show | Contactpage |
#      | "Blog1"       | "Dies ist eine Blogseite1"       | 424 | blog     |           | Default Show | Blog1       |
#      | "Blog2"       | "Dies ist eine Blogseite2"       | 425 | blog2    | 424       | Default Show | Blog2       |
#      | "Blog2-2"     | "Dies ist eine Blogseite22"      | 426 | blog22   | 424       | Default Show | Blog2-2     |
#      | "Blog3"       | "Dies ist eine Blogseite3"       | 427 | blog3    | 425       | Default Show | Blog3       |
#      | "Blog4"       | "Dies ist eine Blogseite4"       | 428 | blog4    | 427       | Default Show | Blog4       |
#      | "Blog5"       | "Dies ist eine Blogseite5"       | 429 | blog5    | 427       | Default Show | Blog5       |
#    Given an empty menu table
#    Then I go to the startpage
#    And I should see "News" within "ul.navigation.main"
#    And I should not see "Invisible" within "ul.navigation.main"
#    And I should see "Contact" within "ul.navigation.main"
#    And I should not see "Blog1" within "ul.navigation.main"
#    And I should not see "Sub-News" within "ul.navigation.main"
#    And I should not see "Sub-News2" within "ul.navigation.main"
#    And I should see "Blog1" within "ul.navigation.bottom"
#    And I should see "Blog2" within "ul.navigation.bottom ul.level_2"
#    And I should see "Blog3" within "ul.navigation.bottom ul.level_3"
#    When I click on "News" within "ul.navigation.main"
#    Then I should see "Dies ist eine Nachrichtenseite"
#    And I should see "News" within "ul.navigation.main li.news.active"
#    When I click on "Blog4" within "ul.navigation.bottom"
#    Then I should see "Blog4" within "ul.navigation.bottom ul.level_4 li.active"
#    When I visit url "/blog/blog2/blog3/blog4?ids=a"
#    Then I should see "Blog4" within "ul.navigation.bottom ul.level_4 li.active"
#    And I should not see "Blog1" within "ul.navigation.bottom li.active"
#    And I should see "Blog1" within "#breadcrumb"
#    And I should see "Blog2" within "#breadcrumb"
#    And I should see "Blog3" within "#breadcrumb"
#    And I should see "Blog4" within "#breadcrumb"

  Scenario: Check a page for all elements
    Given that I am not logged in
    And an article exists with the following attributes:
      | title         | "Seite 1"              |
      | url_name      | seite1                 |
      | subtitle      | "Untertitel"           |
      | summary       | "Zusammenfassung"      |
      | canonical_url | "http://www.google.de" |
      | teaser        | "Dies ist ein Teaser"  |
    When I visit url "/seite1"
    Then I should see "Seite 1" within "h1"
    And I should see "Untertitel"
    And I should see "Zusammenfassung"
    And I should see "Dies ist ein Teaser"
