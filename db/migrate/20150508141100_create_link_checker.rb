class CreateLinkChecker < ActiveRecord::Migration
  def change
    create_table :goldencobra_link_checkers do |t|
      t.integer :article_id
      t.text :target_link
      t.text :position
      t.string :response_code
      t.string :response_time
      t.text :response_error
      t.timestamps
    end
  end
end