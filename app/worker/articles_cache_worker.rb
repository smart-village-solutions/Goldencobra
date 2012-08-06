class ArticlesCacheWorker
  include Sidekiq::Worker
  sidekiq_options queue: "default"

  def perform
    Goldencobra::Article.active.each do |article|
      article.updated_at = Time.now
      article.save
    end
  end

end