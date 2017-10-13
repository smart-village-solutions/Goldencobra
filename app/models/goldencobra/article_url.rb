module Goldencobra
  class ArticleUrl < ActiveRecord::Base
    belongs_to :article, class_name: Goldencobra::Article
    web_url :url

    validates :article_id, presence: true
    validates :url, presence: true, uniqueness: { case_sensitive: false }

    def self.setup(article_id)
      article = Goldencobra::Article.find_by_id(article_id)

      # if an article is deleted, related has_many :urls should be deleted to by definition,
      # so there is nothing else to do
      return true unless article

      # are multiple domains in use?
      if Goldencobra::Domain.any?
        setup_domain_urls(article)
      else
        setup_single_url(article)
      end

      article.descendant_ids.each do |did|
        Goldencobra::ArticleUrl.setup(did)
      end
    end

    def self.setup_domain_urls(article)
      # cleanup old Domain Urls
      Goldencobra::ArticleUrl.where(article_id: article.id).destroy_all
      protocol = Goldencobra::Url.protocol

      Goldencobra::Domain.all.each do |domain|
        new_url = "#{protocol}://#{domain.hostname}#{domain.url_prefix}#{article.public_url}"
        Goldencobra::ArticleUrl.create(article_id: article.id, url: new_url)
      end
    end

    def self.setup_single_url(article)
      article_url = Goldencobra::ArticleUrl.where(article_id: article.id).first_or_create
      if article_url.url != article.absolute_public_url.downcase
        article_url.url = article.absolute_public_url.downcase
        article_url.save
      end
    end
  end
end
