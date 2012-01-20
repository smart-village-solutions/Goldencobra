Feature: visit pages in Frontend
  In find some informations
  As an user
  I see some pages and navigate between them

  Scenario: Visit the startpage with an Mainmenue
    Given that I am not logged in
    And an startarticle exists
    And the following "menues" exist:
      | title               | id  | parent_id | target                    | css_class |
      | "Top Navigation"    | 1   |           |                           | "main"    |
      | "Bottom Navigation" | 2   |           |                           | "bottom"  |
      | "News"              | 3   | 1         | "/news"                   | "news"    |
      | "Sub-News"          | 6   | 3         | "/subnews"                | "subnews" |
      | "Sub-News2"         | 7   | 3         | "/subnews2"               | "subnews" |
      | "Sub-Sub-News2"     | 8   | 7         | "/subnews6"               | "subnews" |
      | "Contact"           | 4   | 1         | "/contact"                |           |
      | "Blog1"             | 5   | 2         | "/blog"                   |           |
      | "Blog2"             | 9   | 5         | "/blog/blog2"             |           |
      | "Blog2-2"           | 13  | 5         | "/blog/blog22"            |           |
      | "Blog3"             | 10  | 9         | "/blog/blog2/blog3"       |           |
      | "Blog4"             | 11  | 10        | "/blog/blog2/blog3/blog4" |"selected" |
      | "Blog5"             | 12  | 10        | "/blog/blog2/blog3/blog5" |           |
    And the following "articles" exist:
      | title                         | content                           | id | url_name   | parent_id |
      | "Newspage"                    | "Dies ist eine Nachrichtenseite"  |  2 |  news      |           |
      | "ContactPage"                 | "Dies ist eine Kontaktseite"      |  3 |  contact   |           |
      | "Blog1"                       | "Dies ist eine Blogseite1"        |  4 |  blog      |           |
      | "Blog2"                       | "Dies ist eine Blogseite2"        |  5 |  blog2     |     4     |
      | "Blog2-2"                     | "Dies ist eine Blogseite22"       |  6 |  blog22    |     4     |
      | "Blog3"                       | "Dies ist eine Blogseite3"        |  7 |  blog3     |     5     |
      | "Blog4"                       | "Dies ist eine Blogseite4"        |  8 |  blog4     |     7     |
      | "Blog5"                       | "Dies ist eine Blogseite5"        |  9 |  blog5     |     7     |
    Then I go to the startpage
    And I should see "News" within "ul.navigation.main"
    And I should see "Contact" within "ul.navigation.main"
    And I should not see "Blog1" within "ul.navigation.main"
    And I should not see "Sub-News" within "ul.navigation.main"
    And I should not see "Sub-News2" within "ul.navigation.main"
    And I should see "Blog1" within "ul.navigation.bottom"
    And I should see "Blog2" within "ul.navigation.bottom ul.level_2"
    And I should see "Blog3" within "ul.navigation.bottom ul.level_3"
    When I click on "News" within "ul.navigation.main"
    Then I should see "Dies ist eine Nachrichtenseite"
    And I should see "News" within "ul.navigation.main li.news.active"
    When I click on "Blog4" within "ul.navigation.bottom"
    Then I should see "Blog4" within "ul.navigation.bottom ul.level_4 li.active"
    When I visit url "/blog/blog2/blog3/blog4?ids=a"
    Then I should see "Blog4" within "ul.navigation.bottom ul.level_4 li.active"
    And I should not see "Blog1" within "ul.navigation.bottom li.active"
