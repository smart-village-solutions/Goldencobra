class AddDefaultArticleTypeForNil < ActiveRecord::Migration
  def up
    Goldencobra::Article.where("article_type IS NULL").each do |a|
      a.article_type = "Default Show"
      a.save
    end
  end

  def down
  end
end
