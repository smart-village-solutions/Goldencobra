# This migration comes from goldencobra (originally 20120120095700)
class CreateGoldencobraMetatags < ActiveRecord::Migration
  def change
    create_table :goldencobra_metatags do |t|
      t.string :name
      t.string :value
      t.integer :article_id

      t.timestamps
    end
  end
end
