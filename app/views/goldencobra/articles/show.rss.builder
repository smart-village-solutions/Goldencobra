xml.instruct! :xml, version: "1.0" 
xml.rss version: "2.0" do
  xml.channel do
    xml.title @article.title
    xml.description @article.content
    xml.link @article.absolute_public_url

    if @list_of_articles
      @list_of_articles.each do |article|
        xml.item do
          xml.title article.title
          xml.description do
            xml.cdata!(article.content)
          end
          xml.pubDate article.published_at.strftime("%a, %d %b %Y %H:%M:%S %z")
          xml.link article.absolute_public_url
          xml.guid article.absolute_public_url
          if article.images && article.images.count > 0
            ai = article.images.first
            xml.tag! "enclosure", :type => ai.image_content_type, :url => "http://#{Goldencobra::Setting.for_key('goldencobra.url')}#{ai.image.url(:thumb)}", :length => ai.image_file_size
            xml.tag! "enclosure", :type => ai.image_content_type, :url => "http://#{Goldencobra::Setting.for_key('goldencobra.url')}#{ai.image.url(:medium)}", :length => ai.image_file_size
          end
          xml.tag! "quirin:rating", "0.0"
          xml.tag! "quirin:teaser" do
           xml.cdata!(article.teaser)
          end
          xml.comments "article_comments_url(article)"
          article.article_type_xml_fields.each do |field, value|
            xml.tag! field, raw(value)
          end
        end
      end
    end
  end
end
