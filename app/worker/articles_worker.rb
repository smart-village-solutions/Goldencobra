class ArticlesWorker
  include Sidekiq::Worker
  sidekiq_options queue: "medium"

  def perform
    Goldencobra::Article.active.each do |article|
      article.updated_at = Time.now
      article.save
    end
  end

end