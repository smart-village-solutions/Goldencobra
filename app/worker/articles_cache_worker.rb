class ArticlesCacheWorker
  include Sidekiq::Worker
  sidekiq_options queue: "default"

  def perform
    #cache leeren
    Goldencobra::Article.active.each do |article|
      article.updated_at = Time.now
      article.without_versioning :save
    end
    #Alte Versionen von has_paper_trail löschen (https://github.com/airblade/paper_trail)
    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      if Goldencobra::Setting.for_key("goldencobra.remove_old_versions.active") == "true"
        weekcount = Goldencobra::Setting.for_key("goldencobra.remove_old_versions.weeks").to_i
        Version.delete_all ["created_at < ?", weekcount.weeks.ago]
      end
    end
  end

end