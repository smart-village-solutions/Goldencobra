# encoding: utf-8

xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Testtitel"
    xml.link "http://localhost:5000"
    xml.description "Meine Beschreibung"
    @articles.each do |article|
      xml.item do
        xml.title "#{article.title}"
        xml.description do
          if article.teaser.present?
            template = Liquid::Template.parse(article.teaser)
          else
            template = Liquid::Template.parse(article.content)
          end
          xml.cdata!(truncate(raw(template.render(Goldencobra::Article::LiquidParser)), length: 200))
        end
        xml.link "#{article.absolute_public_url}"
        xml.pubDate "#{article.created_at.strftime("%a, %d %b %Y %H:%M:%S %z")}"
        xml.guid "#{article.absolute_public_url}"
      end
    end
  end
end
