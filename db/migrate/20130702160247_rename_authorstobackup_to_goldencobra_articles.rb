class RenameAuthorstobackupToGoldencobraArticles < ActiveRecord::Migration
  def up
		rename_column :goldencobra_articles, :author, :author_backup
		add_column :goldencobra_articles, :author_id, :integer
  end

  def down
		rename_column :goldencobra_articles, :author_backup, :author
		remove_column :goldencobra_articles, :author_id
  end
end
