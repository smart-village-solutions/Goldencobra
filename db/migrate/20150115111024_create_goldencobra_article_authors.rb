# encoding: utf-8

class CreateGoldencobraArticleAuthors < ActiveRecord::Migration
  def up
    create_table :goldencobra_article_authors do |t|
      t.integer :article_id
      t.integer :author_id

      t.timestamps
    end

    # migrate data from articles author_id to kreuztabelle
    Goldencobra::Article.where("author_id IS NOT NULL").each do |article|
      Goldencobra::ArticleAuthor.create(article_id: article.id, author_id: article.author_id)
    end
  end

  def down
    # migrate data from goldencobra_article_authors to articles author_id
    Goldencobra::ArticleAuthor.select([:article_id, :author_id]).uniq(:article_id).each do |article_author|
      a = Goldencobra::Article.find_by_id(article_author.article_id)
      a.author_id = article_author.author_id
      a.save
    end

    drop_table :goldencobra_article_authors
  end
end
