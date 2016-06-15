module Goldencobra
  class ArticleUrl < ActiveRecord::Base
    belongs_to :article, class_name: Goldencobra::Article
    web_url :url

    validates :article_id, presence: true
    validates :url, presence: true, uniqueness: { case_sensitive: false }

    def self.setup(article_id)
      article = Goldencobra::Article.find_by_id(article_id)

      # wenn der Artikel gelöscht wurde, sollten die has_many :urls im goldencobra Article
      # ebenfalls gelöscht sein. Somit ist hier nichts mehr zu tun
      return true unless article

      # are multiple domains in use?
      if Goldencobra::Domain.any?
        setup_domain_urls(article)
      else
        setup_single_url(article)
      end

      # Aktualisiere ale URLs der Kinder dieses Artikels
      article.descendants.each do |d|
        Goldencobra::ArticleUrl.setup(d.id)
      end
    end

    def self.setup_domain_urls(article)
      # cleanup old Domain Urls
      Goldencobra::ArticleUrl.where(article_id: article.id).destroy_all

      base = "http://"
      base = "https://" if Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"

      Goldencobra::Domain.all.each do |domain|
        new_url = "#{base}#{domain.hostname}#{domain.url_prefix}#{article.public_url}"
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
