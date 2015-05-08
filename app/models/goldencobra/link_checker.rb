# encoding: utf-8

module Goldencobra
  class LinkChecker < ActiveRecord::Base

    belongs_to :article, :class_name => Goldencobra::Article, :foreign_key => "article_id"

    #get all links of a page and make a check for response status and time
    def self.set_link_checker(article)
      @article = article
      links_to_check = []
      status_for_links = {}

      #Sammle Links auf der Seite
      doc = Nokogiri::HTML(open(article.absolute_public_url))
      #find all links and stylesheets
      doc.css('a,link').each do |link|
        if self.add_link_to_checklist(link, "href", article).present?
          links_to_check << {"link" => add_link_to_checklist(link, "href", article), "pos" => link.path}
        end
      end
      #find all images and javascripts
      doc.css('img,script').each do |link|
        if self.add_link_to_checklist(link,"src", article).present?
          links_to_check << {"link" => add_link_to_checklist(link,"src", article), "pos" => link.path}
        end
      end
      links_to_check = links_to_check.compact.delete_if{|a| a.blank?}

      #generate status_for_links

      links_to_check.each_with_index do |linkpos|
        status_for_links[linkpos["link"]] = {"position" => linkpos["pos"]}
        begin
          start = Time.now
          response = open(linkpos["link"])
          status_for_links[linkpos["link"]]["response_code"] = response.status[0]
          status_for_links[linkpos["link"]]["response_time"] = Time.now - start
        rescue Exception  => e
          status_for_links[linkpos["link"]]["response_code"] = "404"
          status_for_links[linkpos["link"]]["response_error"] = e.to_s
        end
      end

      #save status_for_links to DB
      status_for_links.each do |link_name, value|
        article.link_checks.destroy_all
        Goldencobra::LinkChecker.create(article_id: article.id, target_link: link_name, 
                                        position: value["position"], response_code: value["response_code"], 
                                        response_time: value["response_time"], response_error: value["response_error"] )
      end
      return status_for_links
    end


    private
    #helper method for finding links in html document
    def self.add_link_to_checklist(link, src_type, article)
      begin
        if link.blank? || link[src_type].blank?
          return nil
        elsif link[src_type][0 .. 6] == "http://" || link[src_type][0 .. 6] == "https:/"
          return "#{link[src_type]}"
        elsif link[src_type] && link[src_type][0 .. 1] == "//"
          return "http:/#{link[src_type][/.(.*)/m,1]}"
        elsif link[src_type] && link[src_type][0] == "/"
          return "#{Goldencobra::Setting.absolute_base_url}/#{link[src_type][/.(.*)/m,1]}"
        elsif link[src_type] && !link[src_type].include?("mailto:")
          return "#{article.absolute_public_url}/#{link[src_type]}"
        end
      rescue
        return nil
      end
    end

  end
end