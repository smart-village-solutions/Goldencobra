# encoding: utf-8

xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
#XML Sitemap um Bilder ergänzen: https://support.google.com/webmasters/answer/178636?hl=de
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9', "xmlns:image" => "http://www.google.com/schemas/sitemap-image/1.1" do
#xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @articles.each do |article|
    xml.url do # create the url entry, with the specified location and date
      xml.loc "http#{@use_ssl}://#{@domain_name}#{article.public_url}"
      xml.lastmod article.updated_at.strftime('%Y-%m-%d')
      xml.priority 0.5
      if article.images.any?
        article_image = article.images.first
        if article_image.present?
          xml.tag!("image:image") do
            if article_image.image.present?
              xml.tag!("image:loc", "http#{@use_ssl}://#{@domain_name}#{article_image.image.url(:original)}")
            end
            xml.tag!("image:title", article_image.alt_text.present? ? article_image.alt_text : article.title )
            xml.tag!("image:caption", article_image.description.present? ? article_image.description : article.teaser)
          end
        end
      end
    end
  end
  if File.exists?(File.join(::Rails.root, "app", "views", "articletypes", "default", "_sitemap.xml.builder"))
  	render :partial => "articletypes/default/sitemap.xml.builder"
  end
end