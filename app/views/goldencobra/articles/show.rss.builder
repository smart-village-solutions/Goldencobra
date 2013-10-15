xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title @article.title
    xml.description @article.summary
    xml.link @article.absolute_public_url

    if @list_of_articles
      @list_of_articles.each do |article|
        xml.item do
          xml.title article.title
          xml.description do
            if article.content.present?
              template = Liquid::Template.parse(article.content)
              xml.cdata!(raw(template.render(Goldencobra::Article::LiquidParser)))
            else
              ''
            end
          end
          xml.pubDate article.published_at.strftime("%a, %d %b %Y %H:%M:%S %z")
          xml.link article.absolute_public_url
          xml.guid article.absolute_public_url
          if article.images && article.images.count > 0 && article.images.first.present?
            ai = article.images.first
            xml.tag! "enclosure", :type => ai.image_content_type, :url => "http://#{Goldencobra::Setting.for_key('goldencobra.url')}#{ai.image.url(:medium)}", :length => ai.image_file_size
          end
          xml.cdata!(article.teaser.present? ? article.teaser : '')
        end
      end
    end
  end
end
