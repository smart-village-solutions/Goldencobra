# encoding: utf-8

module Goldencobra
  class LinkChecker
    def initialize(article)
      @article = article
    end

    #get all links of a page and make a check for response status and time
    def set_link_checker
      links_to_check = []
      status_for_links = {}
      doc = Nokogiri::HTML(open(@article.absolute_public_url))
      #find all links and stylesheets
      doc.css('a,link').each do |link|
        if add_link_to_checklist(link, "href").present?
          links_to_check << {"link" => add_link_to_checklist(link, "href"), "pos" => link.path}
        end
      end
      #find all images and javascripts
      doc.css('img,script').each do |link|
        if add_link_to_checklist(link,"src").present?
          links_to_check << {"link" => add_link_to_checklist(link,"src"), "pos" => link.path}
        end
      end
      links_to_check = links_to_check.compact.delete_if{|a| a.blank?}
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

      #@article.link_checker = status_for_links.compact
    end


    private
    #helper method for finding links in html document
    def add_link_to_checklist(link, src_type)
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
          return "#{@article.absolute_public_url}/#{link[src_type]}"
        end
      rescue
        return nil
      end
    end

  end
end