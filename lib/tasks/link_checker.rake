# encoding: utf-8

namespace :link_checker do
  desc 'Checks Links for a given Article'
  task :article => :environment do
    article_id = ENV['ID']

    if article_id.present?
      article = Goldencobra::Article.find(article_id)
      if article
        status = Goldencobra::LinkChecker.get_status_for_article(article)
        article.link_checker = status
        article.save
      end
    else
      puts "Missing Attributes! e.g.:"
      puts "rake link_checker:article ID=8"
    end
  end


  desc 'Checks Links for all Articles'
  task :all => :environment do
    Goldencobra::Article.scoped.each do |article|
      begin
        status = Goldencobra::LinkChecker.get_status_for_article(article)
        article.link_checker = status
        article.save
      rescue
        puts "Artikel konnte nicht geprüft werden: #{article.id}"
      end
    end
  end

end
