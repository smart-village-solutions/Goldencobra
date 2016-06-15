require 'benchmark/ips'

Goldencobra::Setting.set_value_for_key("http://www.ikusei.de", "goldencobra.url")
Goldencobra::Setting.set_value_for_key("false", "goldencobra.use_ssl")

20.times do |i|
  a = Goldencobra::Article.create!(title: "Seite #{i}", breadcrumb: "seite #{i}", article_type: "Default Show", url_name: "seite#{i}", template_file: "application")
  20.times do |ii|
    b = Goldencobra::Article.create!(parent_id: a.id,title: "Seite #{ii}", breadcrumb: "seite #{ii}", article_type: "Default Show", url_name: "seite#{ii}", template_file: "application")
    20.times do |iii|
      Goldencobra::Article.create!(parent_id: b.id,title: "Seite #{iii}", breadcrumb: "seite #{iii}", article_type: "Default Show", url_name: "seite#{iii}", template_file: "application")
    end
  end
end


Benchmark.ips do |x|
  x.report("old-finder") do |times|
    i = 0
    while i < times
      level = [1,2,3].sample
      path = []
      level.times do |l|
        path << "seite#{(0..19).to_a.sample}"
      end
      url = "http://www.ikusei.de/#{path.join("/")}"

      Goldencobra::Redirector.get_by_request(url)
      Goldencobra::Article.search_by_url(path.join("/"))
      i += 1
    end
  end

  x.report("find-by-adapter") do |times|
    i = 0
    while i < times
      level = [1,2,3].sample
      path = []
      level.times do |l|
        path << "seite#{(0..19).to_a.sample}"
      end
      url = "http://www.ikusei.de/#{path.join("/")}"

      article_id = Goldencobra::ArticleAdapter.find(url)
      Goldencobra::Article.find(article_id)
      i += 1
    end
  end

  x.compare!

end