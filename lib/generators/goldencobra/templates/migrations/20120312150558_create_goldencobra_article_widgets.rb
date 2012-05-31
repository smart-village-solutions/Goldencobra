class CreateGoldencobraArticleWidgets < ActiveRecord::Migration
  def change
    create_table :goldencobra_article_widgets do |t|
      t.integer :article_id
      t.integer :widget_id

      t.timestamps
    end
  end
end
