# encoding: utf-8

xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: "2.0", "xmlns:atom"=>"http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag!("atom:link", {"href" => "http://#{Goldencobra::Setting.for_key('goldencobra.url').sub('http://','')}/api/v2/articles.xml", "rel"=>"self", "type"=>"application/rss+xml"})
    xml.title Goldencobra::Article.where(startpage: true).first.title
    xml.link Goldencobra::Article.where(startpage: true).first.absolute_public_url
    xml.description Goldencobra::Metatag.where(article_id: Goldencobra::Article.where(startpage: true).first.id, name: 'Meta Description').first.value
    @articles.uniq.each do |article|
      xml.item do
        xml.title "#{article.title.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')}"
        xml.description do
          if article.teaser.present?
            template = Liquid::Template.parse(article.teaser.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ''))
          else
            template = Liquid::Template.parse(article.content.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ''))
          end
          xml.cdata!(template.render(Goldencobra::Article::LiquidParser))
        end
        xml.link "#{article.absolute_public_url}"
        xml.pubDate "#{article.created_at.strftime("%a, %d %b %Y %H:%M:%S %z")}"
        xml.guid "#{article.absolute_public_url}"
      end
    end
  end
end
