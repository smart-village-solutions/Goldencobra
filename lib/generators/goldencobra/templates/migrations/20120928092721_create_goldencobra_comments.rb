class CreateGoldencobraComments < ActiveRecord::Migration
  def change
    create_table :goldencobra_comments do |t|
      t.integer :article_id
      t.integer :commentator_id
      t.string  :commentator_type
      t.text    :content
      t.boolean :active, :default => true
      t.boolean :approved, :default => false
      t.boolean :reported, :default => false
      t.string  :ancestry

      t.timestamps
    end
  end
end
