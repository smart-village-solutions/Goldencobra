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
          xml.pubDate article.published_at
          xml.link article.public_url
          xml.guid article.public_url
          if article.images && article.images.count > 0
            xml.enclosure article.images.first.image.url(:medium)
          end
          xml.tag! "quirin:rating", "0,0"
          xml.tag! "quirin:teaser", article.summary
          xml.comments "article_comments_url(article)"
        end
      end
    end
  end
end