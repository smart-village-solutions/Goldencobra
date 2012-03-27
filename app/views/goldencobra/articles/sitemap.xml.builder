xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @articles.each do |article|
    xml.url do # create the url entry, with the specified location and date
      xml.loc "http://#{@domain_name}#{article.public_url}"
      xml.lastmod article.updated_at.strftime('%Y-%m-%d')
      xml.priority 0.5
    end
  end
end