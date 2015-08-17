# encoding: utf-8

namespace :article_cache do
  desc 'Recreate cache for children of given article id'
  task :recreate => :environment do
    article_id = ENV['ID']
    article = Goldencobra::Article.find_by_id(article_id)
    custom_children = Goldencobra::Article.where(ancestry: "#{self.ancestry}/#{self.id}")

    if article.present? && custom_children.present?
      custom_children.each do |c|
        c.url_path = c.get_url_from_path
        c.save
      end
    end

  end

end