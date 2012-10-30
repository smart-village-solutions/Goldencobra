require 'spec_helper'

feature 'Visitor visits article' do
  scenario 'which is offline' do
    article_is_offline
    visitor_cannot_see_article
  end

  scenario 'which is_online and has active_since in the past' do
    article_is_active_since_1_week_ago
    visitor_can_see_article
  end

  scenario 'which is online but active_since is in the future' do
    article_is_active_in_1_week
    visitor_cannot_see_article
  end

  private

  def article_is_offline
    Goldencobra::Article.create(title: 'Foo title', active: false, active_since: Time.now - 1.week)
  end

  def article_is_active_in_1_week
    Goldencobra::Article.create(title: 'Foo title', active: true, active_since: Time.now + 1.week)
  end

  def article_is_active_since_1_week_ago
    Goldencobra::Article.create(title: 'Online title', active: true, active_since: Time.now - 1.week)
  end

  def visitor_cannot_see_article
    visit "/admin/logout"
    article = Goldencobra::Article.where(title: 'Foo title').first
    visit article.absolute_public_url
    page.should have_content('404')
  end

  def visitor_can_see_article
    visit "/admin/logout"
    article = Goldencobra::Article.where(title: 'Online title').first
    visit article.absolute_public_url
    page.should have_content('Online title')
  end
end