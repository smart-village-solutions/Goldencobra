# encoding: utf-8
module Goldencobra
  class Article < ActiveRecord::Base

    def self.search_by_url(url)
      article = nil
      articles = Goldencobra::Article.where(:url_name => url.split("/").last.to_s.split(".").first)
      article_path = "/#{url.split('.').first}"
      if articles.count > 0
        article = articles.select{|a| a.public_url(false) == article_path}.first
      end
      return article
    end


    def parent_path
      self.path.map(&:title).join(" / ")
    end


    def public_url(with_prefix=true)
      if self.startpage
        if with_prefix
          return "#{Goldencobra::Domain.current.try(:url_prefix)}/"
        else
          return "/"
        end
      else

        #url_path in der Datenbank als string speichern und beim update von ancestry neu berechnen... ansosnten den urlpafh aus dem string holen statt jedesmal über alle eltern iterierne
        if self.url_path.blank? || self.url_path_changed? || self.url_name_changed? || self.ancestry_changed?
          a_url = self.get_url_from_path
        else
          a_url = self.url_path
        end

        if with_prefix
          return "#{Goldencobra::Domain.current.try(:url_prefix)}#{a_url}"
        else
          return a_url
        end
      end
    end


    def absolute_base_url
      if Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"
        "https://#{Goldencobra::Setting.for_key('goldencobra.url')}"
      else
        "http://#{Goldencobra::Setting.for_key('goldencobra.url')}"
      end
    end


    def absolute_public_url
      if Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"
        "https://#{Goldencobra::Setting.for_key('goldencobra.url')}#{self.public_url}"
      else
        "http://#{Goldencobra::Setting.for_key('goldencobra.url')}#{self.public_url}"
      end
    end


    def for_friendly_name
      if self.url_name.present?
        self.url_name
      elsif self.breadcrumb.present?
        self.breadcrumb
      else
        self.title
      end
    end

  end
end