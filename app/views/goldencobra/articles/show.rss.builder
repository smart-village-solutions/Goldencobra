xml.instruct! :xml, version: "1.0" 
xml.rss version: "2.0" do
  xml.channel do
    xml.title @article.title
    xml.description @article.teaser
    xml.link @article.public_url
    
    if @list_of_articles
      @list_of_articles.each do |article|
        xml.item do
          xml.title article.title
          xml.description article.teaser
          xml.pubDate article.published_at.to_s(:rfc822)
          xml.link article.public_url
          xml.guid article.public_url
        end
      end
    end
  end
end