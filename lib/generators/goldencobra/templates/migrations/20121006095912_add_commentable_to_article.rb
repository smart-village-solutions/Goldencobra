class AddCommentableToArticle < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :commentable, :boolean, :default => false
  end
end
