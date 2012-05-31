class CreateArticles < ActiveRecord::Migration
  def change
    create_table :goldencobra_articles do |t|
      t.string :title

      t.timestamps
    end
  end
end
