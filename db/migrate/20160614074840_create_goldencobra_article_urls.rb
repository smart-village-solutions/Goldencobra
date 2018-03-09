class CreateGoldencobraArticleUrls < ActiveRecord::Migration[4.2]
  def change
    create_table :goldencobra_article_urls do |t|
      t.integer :article_id
      t.text :url

      t.timestamps null: false
    end
  end
end
