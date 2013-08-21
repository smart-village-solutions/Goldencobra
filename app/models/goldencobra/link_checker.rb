module Goldencobra
  class LinkChecker
    #get all links of a page and make a check for response status and time
    def self.get_status_for_article(article)
      links_to_check = []
      status_for_links = {}
      doc = Nokogiri::HTML(open(article.absolute_public_url))
      #find all links and stylesheets
      doc.css('a,link').each do |link|
        links_to_check << self.add_link_to_checklist(link, "href")
      end
      #find all images and javascripts
      doc.css('img,script').each do |link|
        links_to_check << self.add_link_to_checklist(link,"src")
      end
      links_to_check = links_to_check.compact.delete_if{|a| a.blank?}
      links_to_check.each_with_index do |link|
        status_for_links[link] = {}
        begin
          start = Time.now
          response = open(link)
          status_for_links[link]["response_code"] = response.status[0]
          status_for_links[link]["response_time"] = Time.now - start
        rescue Exception  => e
          status_for_links[link]["response_code"] = "404"
          status_for_links[link]["response_error"] = e.to_s
        end
      end
      status_for_links
    end

    #helper method for finding links in html document
    def self.add_link_to_checklist(link, src_type)
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
