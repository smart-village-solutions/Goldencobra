class AddRemoveAuthorStuff < ActiveRecord::Migration
  def up
    remove_column :goldencobra_articles, :author_id
    remove_column :goldencobra_articles, :author_backup
  end

  def down
    add_column :goldencobra_articles, :author_id, :integer
    add_column :goldencobra_articles, :author_backup, :string
  end
end
